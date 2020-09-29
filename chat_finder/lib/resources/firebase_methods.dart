import 'dart:io';
import 'package:chat_finder/models/message.dart';
import 'package:chat_finder/models/user.dart';
import 'package:chat_finder/provider/image_upload_provider.dart';
import 'package:chat_finder/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_finder/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore _firestore = Firestore.instance;

  static final CollectionReference _userCollection = _firestore.collection(USERS_COLLECTION);

  StorageReference _storageReference;

  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot = await _userCollection.document(currentUser.uid).get();

    return User.fromMap(documentSnapshot.data);
  }

  Future<FirebaseUser> signIn() async {
    print("Method calling...");
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuth = await _signInAccount.authentication;
    print("trying to sign in");
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuth.idToken,
        accessToken: _signInAuth.accessToken
    );
    print(credential.providerId);
    AuthResult result = await _auth.signInWithCredential(credential);
    FirebaseUser user = result.user;
    print(result.user);
    return user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _auth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return authResult.user;
      } else {
        throw PlatformException(

          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      print("No google account");
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  Future<FirebaseUser> signInWithFacebook() async {
    print("Method calling...");
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(
      ['public_profile'],
    );
    if (result.accessToken != null) {
      print("trying to sign in");
      final authResult = await _auth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        ),
      );
      print(authResult.user);
      return authResult.user;
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }
  
  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await _firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  Future<void> registerUser(User user) async {
    _firestore
        .collection(USERS_COLLECTION)
        .document(user.uid)
        .setData(user.toMap(user));
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _auth.signOut();
  }

  Future<List<User>> fetchAllUsers(FirebaseUser user) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await _firestore.collection(USERS_COLLECTION).getDocuments();

    for(int i = 0; i< querySnapshot.documents.length; i++){
      if(querySnapshot.documents[i].documentID != user.uid){
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }

    return userList;
  }

  Future<void> addMessageToDb(message, User sender, User receiver) async {
    var map = message.toMap();

    await _firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    return await _firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  fetchUserDetailsByUid(String uid) {}

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance.ref().child('${DateTime.now().millisecondsSinceEpoch}');

      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);

      var url = await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message _message;

    _message = Message.imageMessage(
      message: "IMAGE",
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timestamp: Timestamp.now(),
      type: 'image',
    );

    var map = _message.toImageMap();

    await _firestore
        .collection(MESSAGES_COLLECTION)
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await _firestore
        .collection(MESSAGES_COLLECTION)
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  void uploadImage(File image, String receiverId, String senderId, ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();

    String url = await uploadImageToStorage(image);

    imageUploadProvider.setToIdle();

    setImageMsg(url, receiverId, senderId);
  }

  Future <List<String>> getTopics() async {
    final topics = await _firestore
        .collection(TOPIC_COLLECTION)
        .document(TOPIC_COLLECTION).get();

    List<String> topicValues = new List<String>();
    topics.data.values.toList().forEach((element) {topicValues.add(element.toString());});
    return topicValues;
  }

  Future<String> uploadProfileImage(File image, ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();

    String url = await uploadImageToStorage(image);

    imageUploadProvider.setToIdle();

    return url;
  }

  Future<List<User>> getAllActiveCallers() async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
    await _firestore.collection(USERS_CALLING).getDocuments();

    for(int i = 0; i< querySnapshot.documents.length; i++){
      if(querySnapshot.documents[i].documentID != user.uid){
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }

    await getUserDetails().then((value) => userList.remove(value));

    return userList;
  }

  Future<void> addToActiveCallers(User user) async {
    _firestore
        .collection(USERS_CALLING)
        .document(user.uid)
        .setData(user.toMap(user));
  }

  Future<void> removeFromActiveCallers(User user) async {
    _firestore
        .collection(USERS_CALLING)
        .document(user.uid)
        .delete();
  }
}