import 'dart:io';
import 'package:chat_finder/models/message.dart';
import 'package:chat_finder/models/user.dart';
import 'package:chat_finder/provider/image_upload_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

  //Future<FirebaseUser> signIn() => _firebaseMethods.signIn();
  Future<FirebaseUser> signInWithGoogle() => _firebaseMethods.signIn();

  Future<FirebaseUser> signInWithFacebook() => _firebaseMethods.signInWithFacebook();

  Future<bool> authenticateUser(FirebaseUser user) => _firebaseMethods.authenticateUser(user);

  registerUser(User user) => _firebaseMethods.registerUser(user);

  Future<void> signOut() => _firebaseMethods.signOut();

  Future<List<User>> fetchAllUsers(FirebaseUser user) => _firebaseMethods.fetchAllUsers(user);

  Future<User> fetchUserDetailsByUid(String uid) => _firebaseMethods.fetchUserDetailsByUid(uid);

  Future<void> addMessageToDb(Message message, User sender, User receiver) => _firebaseMethods.addMessageToDb(message, sender, receiver);

  void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
  }) => _firebaseMethods.uploadImage(
    image,
    receiverId,
    senderId,
    imageUploadProvider,
  );

  Future<User> getUserDetails() => _firebaseMethods.getUserDetails();

  Future<List<String>> getTopics() => _firebaseMethods.getTopics();

  Future<String> uploadProfileImage({
    File image,
    ImageUploadProvider imageUploadProvider
  }) => _firebaseMethods.uploadProfileImage(
    image,
    imageUploadProvider,
  );

  Future<List<User>> getAllActiveCallers() => _firebaseMethods.getAllActiveCallers();

  Future<void> addToActiveCallers(User user) => _firebaseMethods.addToActiveCallers(user);

  Future<void> removeFromActiveCallers(User user) => _firebaseMethods.removeFromActiveCallers(user);
}