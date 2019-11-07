"use strict";
var express = require('express');
var router= express.Router();
const admin = require("firebase-admin");
const db = admin.firestore();
const docRef = db.collection('usuarios');

module.exports = router;

router.get("/", function(req, res){
    //Leer documento
    let user_dict = {};
    docRef.get()
    .then(snapshot => {
      snapshot.forEach(doc => {
        console.log(doc.id, '=>', doc.data());
        user_dict[doc.id]=doc.data();
        //res.send("<p>"+doc.id+" => "+JSON.stringify(doc.data())+"</p>");
      });
      return res.send(user_dict);
    }).catch(err => {
      console.log('Error getting documents', err);
    });
});

router.post("/add", (req, res) =>{
    //Agregar documento con id automatica
    docRef.add(req.body).then(ref => {
        console.log('Added document with ID: ', ref.id);
        return res.status(200).end();
      }).catch(error =>{
        console.log("Shuuuu, te me caiste :c ", error);
    });
});
