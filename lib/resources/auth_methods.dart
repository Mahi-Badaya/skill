import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intro/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //signup
  Future <String> signUpUser ({
    required String email,
    required String password,
    required String username,
   required Uint8List file,
  }) async {
      String res = "Some error occured";
      try{
        if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || file != null){
          //register
          UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
          print(cred.user!.uid);

          String photoUrl= await StorageMethods().uploadImageToStorage('profilePics', file, false);
          //adding user to database
          await _firestore.collection('users').doc(cred.user!.uid).set({
            'username' :username,
            'uid' : cred.user!.uid,
            'email' : email,
            'photoUrl' :photoUrl,
          });
          res="success";
        }

      }catch(err){
        res= err.toString();
      }
      return res;
  }

  //Login
  Future <String> loginUser ({
    required String email,
    required String password,
  }) async{
    String res = "Some Error Occured";

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }else{
        res= "Please enter all the fields";
      }
    }
    catch(err){
        res = err.toString();
    }
    return res;
  }
}