import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class Auth
{
  Future<void> registerUser(String email, String password, BuildContext context) async
  {
    try
    {
      final FirebaseAuth user = FirebaseAuth.instance;
      UserCredential userCredential = await user.createUserWithEmailAndPassword(
          email: email, password: password);

      _checkAndCreateUserDocument(userCredential.user!, context, password);
      //user.sendSignInLinkToEmail(email: email, actionCodeSettings: ActionCodeSettings(url: url))
    }
    catch (e)
    {

    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password, BuildContext context) async
  {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try
    {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      context.go('/home');
    }
    catch (e)
    {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final querySnapshot = await db.collection('users').where('email', isEqualTo: email).get();
      final isCorrectPassword = await db.collection('users').where('password', isEqualTo: password).get();

      if(querySnapshot.docs.isEmpty)
      {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("The user does not exist, you must register first"),
              backgroundColor: const Color.fromARGB(255, 255, 0, 0),
            )
        );
      }
      else if(isCorrectPassword.docs.isEmpty)
      {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("The password is incorrect"),
              backgroundColor: const Color.fromARGB(255, 255, 0, 0),
            )
        );
      }

    }
  }

  Future<void> signInWithGoogle(BuildContext context) async
  {
    final FirebaseAuth user = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(serverClientId: "1000195925520-i7tabc9vhcanbnfj11qoujabkoso8p3g.apps.googleusercontent.com");

    final GoogleSignInAccount googleAuth = await googleSignIn.authenticate();

    final GoogleSignInAuthentication auth = googleAuth.authentication;
    String idToken = auth.idToken!;

    final credential = GoogleAuthProvider.credential(idToken: idToken);

    await user.signInWithCredential(credential);

    context.go('/home');
  }

  Future<void> _checkAndCreateUserDocument(User user, BuildContext context, String? password) async
  {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final userDoc = _firestore.collection('users').doc(user.uid);

    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists)
    {
      if (user.providerData.first != "google.com")
      {
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'password': password,
          'displayName': user.displayName ?? '',
          'provider': user.providerData[0].providerId,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text("Account created successfully!"),
            backgroundColor: Color.fromARGB(255, 92, 200, 214),
          ),
        );
      }
      else
      {
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName ?? '',
          'provider': user.providerData[0].providerId,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text("Account created successfully!"),
            backgroundColor: Color.fromARGB(255, 92, 200, 214),
          ),
        );
      }

      context.go('/home');
    }
    else
    {
      await userDoc.update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    }

    context.go('/home');
  }

  Future<void> sendMessage(String message) async
  {
    try
    {
      final user = FirebaseAuth.instance.currentUser;
      final messages = FirebaseFirestore.instance;

      Map<String, dynamic> data = {user!.uid:
        {
          'name': user.displayName,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        }
      };

      await messages.collection('messages').doc().set(data);
    }
    catch (e)
    {

    }
  }
}