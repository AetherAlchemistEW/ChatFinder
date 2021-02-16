import 'package:chat_finder/models/user.dart';
import 'package:chat_finder/resources/firebase_repository.dart';
import 'package:chat_finder/utils/call_utilities.dart';
import 'package:chat_finder/widgets/topicSelectionCard.dart';
import 'package:flutter/material.dart';
//import 'package:gradient_app_bar/gradient_app_bar.dart';

class QueueScreen extends StatefulWidget {
  @override
  _QueueScreenState createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  final FirebaseRepository _repository = FirebaseRepository();
  CallUtils _callUtils = CallUtils();
  bool isQueued = false;
  User us;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), /*GradientAppBar(
        gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor]),
        title: Text("Find a chat",
        style: Theme.of(context).primaryTextTheme.headline4,),
      ),*/

      body: Align(
        alignment: Alignment.center,
        child: Center(
          child: isQueued
              ? Stack(
            children: <Widget>[
              //Show ad
              //Leave queue button
              GestureDetector(
                onTap: _leaveCall,
                child: Container(
                  alignment: Alignment.center,
                  width: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.call_end),
                      Text("Stop Searching"),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(strokeWidth: 10),
                ],
              ),
              /*RaisedButton(
                child: Text("Leave Queue", style: Theme.of(context).primaryTextTheme.button,),
                onPressed: _leaveCall,
              )*/
            ],
          )
          : GestureDetector(
            onTap: () => _findCall(context),
            child: Container(
              alignment: Alignment.center,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.call),
                  Text("Find Call!"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _findCall(BuildContext context) async {
    us = await Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return TopicSelectionCard();
        })
    );

    //print(isQueued);
    setState(() {
      isQueued = true;
    });
    List<User> activeCallers = await _repository.getAllActiveCallers();

    await _repository.addToActiveCallers(us);

    //set topics from card
    //search for best match
    if(activeCallers != null){
      User callUser = _bestUser(us, activeCallers);
      if(callUser != null) {
        if (callUser.uid != us.uid) {
          CallUtils.dial(from: us, to: callUser, context: context);
        }
      } else {
        print("No available calls");
      }
      //return dialog
      //if accept, leave active callers
      //if decline, find next best match
    } else {
      //wait a while, try again.
      print("no-one else queued");
    }
  }

  _leaveCall() async {
    //print(isQueued);
    setState(() {
      isQueued = false;
    });
    //leave active caller list
    await _repository.removeFromActiveCallers(us);
  }

  User _bestUser(User caller, List<User>availableCallers) {
    List<String> callerTopics = List();
    callerTopics.add(caller.topicOne);
    callerTopics.add(caller.topicTwo);
    callerTopics.add(caller.topicThree);
    callerTopics.add(caller.topicFour);
    callerTopics.add(caller.topicFive);

    User bestUser;
    int bestScore = 0;
    for(int i = 0; i < availableCallers.length; i++){
      if(availableCallers[i] == us){
        continue;
      }
      List<String> theirTopics = List();
      theirTopics.add(availableCallers[i].topicOne);
      theirTopics.add(availableCallers[i].topicTwo);
      theirTopics.add(availableCallers[i].topicThree);
      theirTopics.add(availableCallers[i].topicFour);
      theirTopics.add(availableCallers[i].topicFive);
      int score = 0;
      for(int j = 0; j < 4; j++){
        if(theirTopics.contains(callerTopics[j])){
          score ++;
        }
      }
      if(score > bestScore){
        bestScore = score;
        bestUser = availableCallers[i];
      }
    }
    return bestUser;
  }
}
