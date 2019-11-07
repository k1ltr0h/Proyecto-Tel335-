const functions = require('firebase-functions');
const express = require('express');
const dust = require('dustjs-linkedin');
const cons = require("consolidate");
const cors = require("cors");
const app = express();
//Cloud Firestore
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  //credential: admin.credential.applicationDefault(),
  databaseURL: "https://pro355.firebaseio.com"
});
//Vars
var corsOptions = {
  "origin": "*",
  "methods": "GET,HEAD,PUT,PATCH,POST,DELETE",
  "preflightContinue": false,
  "optionsSuccessStatus": 204
};
var usuario = require('./routes/user.js');

app.all("*",cors(corsOptions));
app.engine("dust", cons.dust);
app.set("view engine", "dust");
app.set("views", ".//views");
app.use("/usuario", usuario);

app.get("/", (req, res) =>{
    console.log("hola");
    res.render("index.dust");
});
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.app = functions.https.onRequest(app);
