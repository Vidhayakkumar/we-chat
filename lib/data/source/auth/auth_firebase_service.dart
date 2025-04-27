import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../models/auth/create_user_req.dart';
import '../../models/auth/signin_user_req.dart';

abstract class AuthFirebaseService{

  Future<Either> signup(CreateUserReq createUserReq);

  Future<Either> signIn(SignInUserReq signInUserReq);

}

class AuthFirebaseServiceImp extends AuthFirebaseService{

  @override
  Future<Either> signIn(SignInUserReq signInUserReq)async {
    try{


     UserCredential userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: signInUserReq.email!,
          password: signInUserReq.password!
      );

          return Right('User Login Successfully');

    }on FirebaseAuthException catch(e){
      String message = '';

      if(e.code == 'user-not-found'){
        message = 'User does not exists';
      }else if(e.code ==  'wrong-password'){
        message = 'Wrong password provide for that user';
      }else if(e.code == 'invalid-email') {
        message =' Invalid email ';
      }else {
        message= ' user not found';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try{


     UserCredential userCredential =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: createUserReq.email,
          password: createUserReq.password
      );

      return Right('Signup was successfuly');

    }on FirebaseAuthException catch(e){

      String message = '';

      if(e.code == 'weak-password'){
        message = 'The password provided is too weak';
      }else if(e.code ==  'email-already-in-use'){
        message = 'An account already exists with that email';
      }else if(e.code ==7){
        message = 'Please check your Internet connection';
      }

      return Left(message);


    }
  }

}