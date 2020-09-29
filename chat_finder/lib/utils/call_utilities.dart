import 'dart:math';
import 'package:chat_finder/models/call.dart';
import 'package:chat_finder/models/user.dart';
import 'package:chat_finder/resources/call_methods.dart';
import 'package:chat_finder/screens/call_screen.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.username,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.username,
      receiverPic: to.profilePhoto,
      channelId: from.uid+to.uid+Random().nextInt(10).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if(callMade){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CallScreen(call: call)),
      );
    }
  }
}