import admin from 'firebase-admin';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { setGlobalOptions, logger } from 'firebase-functions';

admin.initializeApp();

const db = getFirestore();
const messaging = getMessaging();

setGlobalOptions({ region: 'europe-west1' });

export const scheduleMatchNotification = onDocumentCreated(
  'matches/{matchId}',
  async (event) => {
    const matchData = event.data?.data();
    if (!matchData || !matchData.date) {
      logger.warn('No match data or date found.');
      return null;
    }

    const matchDate = matchData.date.toDate();
    const now = new Date();
    const notificationTime = new Date(
      matchDate.getTime() - 1000 * 60 * 60 * 12
    );

    if (matchDate < now) {
      const usersSnapshot = await admin.firestore().collection('users').get();
      const tokens = [];
      usersSnapshot.forEach((doc) => {
        const userData = doc.data();
        if (userData.fcmToken && doc.id !== matchData.userId) {
          tokens.push(userData.fcmToken);
        }
      });

      if (tokens.length === 0) {
        logger.warn('No users to notify.');
        return null;
      }

      const payload = {
        notification: {
          title: 'New match!',
          body: `New match with past date on court ${matchData.court} added!`,
        },
        data: {
          type: 'match_added',
        },
        android: {
          priority: 'high',
          notification: {
            channelId: 'high_priority_channel',
            sound: 'default',
          },
        },
        apns: {
          payload: {
            aps: {
              contentAvailable: true,
              sound: 'default',
            },
          },
          headers: {
            'apns-priority': '10',
          },
        },
        tokens,
      };

      try {
        const response = await messaging.sendEachForMulticast(payload);
        logger.info(
          `Notifications sent: ${response.successCount} success, ${response.failureCount} failed`
        );
        await doc.ref.delete();
      } catch (error) {
        logger.error('Error sending notifications:', error);
      }
    } else {
      await db.collection('scheduled_notifications').add({
        userId: matchData.userId,
        matchId: event.params.matchId,
        createdAt: Timestamp.fromDate(now),
        sendAt: Timestamp.fromDate(notificationTime),
      });
    }
  }
);

export const processScheduledNotifications = onSchedule(
  'every 1 hours',
  async () => {
    const now = Timestamp.now();
    const snapshot = await db
      .collection('scheduled_notifications')
      .where('sendAt', '<=', now)
      .get();

    if (snapshot.empty) {
      logger.info('No scheduled notifications to send.');
      return null;
    }

    const usersSnapshot = await db.collection('users').get();
    const tokens = usersSnapshot.docs
      .map((doc) => doc.data().fcmToken)
      .filter(Boolean);

    if (tokens.length === 0) {
      logger.warn('No users to notify.');
      return null;
    }

    for (const doc of snapshot.docs) {
      const { matchId } = doc.data();
      const matchDoc = await db.collection('matches').doc(matchId).get();

      if (!matchDoc.exists) {
        logger.warn('Match not found:', matchId);
        continue;
      }

      const matchData = matchDoc.data();
      const payload = {
        notification: {
          title: 'Upcoming match!',
          body: `Your match on court ${matchData.court} is coming up soon!`,
        },
        data: {
          type: 'scheduled_match_reminder',
        },
        android: {
          priority: 'high',
          notification: {
            channelId: 'high_priority_channel',
            sound: 'default',
          },
        },
        apns: {
          payload: {
            aps: {
              contentAvailable: true,
              sound: 'default',
            },
          },
          headers: {
            'apns-priority': '10',
          },
        },
        tokens,
      };

      try {
        const response = await messaging.sendEachForMulticast(payload);
        logger.info(
          `Notifications sent: ${response.successCount} success, ${response.failureCount} failed`
        );
        await doc.ref.delete();
      } catch (error) {
        logger.error('Error sending notifications:', error);
      }
    }
  }
);
