import admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp();

export const sendAddMatchNotification = functions.database.onValueCreated(
  {
    ref: 'league-matches/{matchId}',
    instance: 'squashy-*',
    region: 'europe-west1',
  },
  async (event) => {
    const matchData = event.data.val();
    const senderId = matchData.userId;

    functions.logger.info('Match data for add', matchData);

    const title = 'League matches list changed!';
    const body = 'A new match has been scheduled!';

    const usersSnapshot = await admin.firestore().collection('users').get();
    const tokens = [];

    usersSnapshot.forEach((doc) => {
      functions.logger.info('User data:', doc.data());
      const userData = doc.data();
      if (userData.fcm_token && doc.id !== senderId) {
        tokens.push(userData.fcm_token);
      }
    });

    if (tokens.length === 0) {
      functions.logger.warn('No users to notify.');
      return null;
    }

    const payload = {
      notification: {
        title,
        body,
      },
      data: {
        type: 'match_added',
      },
      tokens,
    };

    await admin.messaging().sendEachForMulticast(payload);
  }
);

export const sendRemoveMatchNotification = functions.database.onValueDeleted(
  {
    ref: 'league-matches/{matchId}',
    instance: 'squashy-*',
    region: 'europe-west1',
  },
  async (event) => {
    const matchData = event.data.val();
    const senderId = matchData.userId;

    functions.logger.info('Match data for remove', matchData);

    const title = 'League matches list changed!';
    const body = 'One match from the list has been removed!';

    const usersSnapshot = await admin.firestore().collection('users').get();
    const tokens = [];

    usersSnapshot.forEach((doc) => {
      const userData = doc.data();
      if (userData.fcm_token && doc.id !== senderId) {
        tokens.push(userData.fcm_token);
      }
    });

    if (tokens.length === 0) {
      functions.logger.warn('No users to notify.');
      return null;
    }

    const payload = {
      notification: {
        title,
        body,
      },
      data: {
        type: 'match_removed',
      },
      tokens,
    };

    await admin.messaging().sendEachForMulticast(payload);
  }
);

export const sendUpdateMatchNotification = functions.database.onValueUpdated(
  {
    ref: 'league-matches/{matchId}',
    instance: 'squashy-*',
    region: 'europe-west1',
  },
  async (event) => {
    const matchData = event.data.val();
    const senderId = matchData.userId;

    functions.logger.info('Match data for update', matchData);

    const title = 'League matches list changed!';
    const body = 'One match from the list has been updated!';

    const usersSnapshot = await admin.firestore().collection('users').get();
    const tokens = [];

    usersSnapshot.forEach((doc) => {
      const userData = doc.data();
      if (userData.fcm_token && doc.id !== senderId) {
        tokens.push(userData.fcm_token);
      }
    });

    if (tokens.length === 0) {
      functions.logger.warn('No users to notify.');
      return null;
    }

    const payload = {
      notification: {
        title,
        body,
      },
      data: {
        type: 'match_updated',
      },
      tokens,
    };

    await admin.messaging().sendEachForMulticast(payload);
  }
);
