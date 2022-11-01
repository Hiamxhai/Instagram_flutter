import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<model.User> getUserDetails() async {
    // call User => get uid
    User currentUser = _auth.currentUser!;

    // get uid
    DocumentSnapshot snap = await
    _firestore.collection('user').doc(currentUser.uid).get();

     return model.User.fromSnap(snap);



  }

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await  StorageMethod().uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        // add user to our database
        await _firestore.collection('user')
            .doc(cred.user!.uid)
            .set(user.toJson());


        // await _firestore.collection('user').add({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });
        res = 'success';
      }
    } on FirebaseAuthException catch(err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted.';
      }
      else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 character';
      }
    }
    catch (err) {
      res = err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password
  }) async{
    String res = "Some error occurred";
    try {
      if(email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success" ;
      } else {
        return res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch(e) {
        if(e.code == 'wrong-password') {

        }
    }
    catch (err) {
      res = err.toString();
      }
      return res;
    }
    Future<void> signOut() async {
      await _auth.signOut();
    }
}
