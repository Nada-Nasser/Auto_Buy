/*const firebase = require('firebase');

const config = require('./config');

const db = firebase.initializeApp(config.firebaseConfig);

module.exports = db;*/
const admin = require('firebase-admin');
var path = require('path');
const serviceAccount = require( path.resolve( __dirname, "./auto-buy-e8bc2-firebase-adminsdk-a68if-d2b5d34010.json" ) );


admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: 'auto-buy-e8bc2.appspot.com'
});
module.exports=admin;