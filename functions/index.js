import admin from 'firebase-admin';
import { getMessaging } from 'firebase-admin/messaging';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { setGlobalOptions, logger } from 'firebase-functions';

admin.initializeApp();

const messaging = getMessaging();

setGlobalOptions({ region: 'europe-west1' });

export const newMatchNotification = onDocumentCreated(
  'matches/{matchId}',
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      logger.error('No snapshot found!');
      return null;
    }

    const matchData = snapshot.data();
    if (!matchData) {
      logger.error('No match data found.');
      return null;
    }

    const payload = {
      notification: {
        title: 'New match!',
        body: 'New match was created! Tap to check the details.',
      },
      data: {
        type: 'match_added',
      },
      topic: 'matches',
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
    };

    try {
      await messaging.send(payload);
    } catch (error) {
      logger.error('Error sending notifications:', error);
    }
  }
);
