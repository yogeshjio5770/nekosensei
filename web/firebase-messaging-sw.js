/* Firebase Cloud Messaging service worker for NekoSensei web push. */
importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyAxwRK5X9h3wBF7GwhpVNPutl8Hg-eu-1M',
  appId: '1:301384322009:web:68502a1cea130c008c67c8',
  messagingSenderId: '301384322009',
  projectId: 'nekosensei-9a95c',
  authDomain: 'nekosensei-9a95c.firebaseapp.com',
  storageBucket: 'nekosensei-9a95c.firebasestorage.app',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Background message:', payload);
});
