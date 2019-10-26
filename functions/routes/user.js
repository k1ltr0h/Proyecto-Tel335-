"use strict";
var express = require('express');
var router= express.Router();
const admin = require("firebase-admin");
const db = admin.firestore();
const docRef = db.collection('user');

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
      res.send(user_dict);
      return snapshot;
    }).catch(err => {
      console.log('Error getting documents', err);
    });
    //console.log("Aquí estoy o.o");
});

router.post("/add", () =>{
    //Agregar documento con id automatica
    docRef.add({
        nombre: 'Lalo'
      }).then(ref => {
        console.log('Added document with ID: ', ref.id);
        return null;
      }).catch(error =>{
        console.log("Shuuuu, te me caiste :c ", error);
    });
});
