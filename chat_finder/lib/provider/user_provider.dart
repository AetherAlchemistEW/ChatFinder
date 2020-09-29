import 'package:chat_finder/models/user.dart';
import 'package:chat_finder/resources/firebase_repository.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  User get getUser => _user;

  void refreshUser() async {
    User user = await _firebaseRepository.getUserDetails();
    _user = user;
    print("Current user is $_user");
    notifyListeners();
  }
}