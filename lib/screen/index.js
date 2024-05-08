const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
  .document('events/{eventId}')
  .onCreate(async (snapshot, context) => {
    try {
      const eventData = snapshot.data();
      const eventName = eventData.name;
      const eventDate = eventData.date;
      const eventDescription = eventData.description;

      // Retrieve list of subscribed users from Firestore
      const subscribedUsers = await admin.firestore().collection('events').where('eventNotifications', '==', true).get();

      // Send notification to each subscribed user
      subscribedUsers.forEach(async (user) => {
        const notification = {
          notification: {
            title: 'New Event Added!',
            body: `${eventName} on ${eventDate}: ${eventDescription}`,
          },
          token: user.data().fcmToken,
        };
        await admin.messaging().send(notification);
      });

      return null; // Important to return null or a Promise
    } catch (error) {
      console.error('Error sending notification:', error);
      return null; // Return null or a Promise even in case of error
    }
  });
