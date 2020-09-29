import 'package:chat_finder/models/user.dart';
import 'package:chat_finder/resources/firebase_repository.dart';
import 'package:chat_finder/widgets/image_upload_button.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chat_finder/provider/image_upload_provider.dart';
import 'package:chat_finder/utils/utilities.dart';
import 'package:image_picker/image_picker.dart';

class TopicSelectionCard extends StatefulWidget {
  @override
  _TopicSelectionCardState createState() => _TopicSelectionCardState();
}

class _TopicSelectionCardState extends State<TopicSelectionCard> {
  User user;
  FirebaseRepository _repository = FirebaseRepository();
  List <String> topics;
  //Text controllers
  //TextEditingController usernameController = TextEditingController();

  //String imagePath = "";
  //ImagePicker picker = ImagePicker();
  //ImageUploadProvider _imageUploadProvider = ImageUploadProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    topics = new List<String>();
    _getUser();
    _getTopics();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.all(30),
      elevation: 2,
      child: topics.length == 0 || user == null ? Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
          child: Column(
            children: <Widget>[
              Text("Create Profile"),
              //TOPIC WIDGET
              topicSelectorOne(),
              topicSelectorTwo(),
              topicSelectorThree(),
              topicSelectorFour(),
              topicSelectorFive(),
              FlatButton(
                  child: Text("Submit"),
                  onPressed: () => setAndExit(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setAndExit() async {
    Navigator.pop(context, user);
  }

  Widget topicSelectorOne(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        hint: Text("Choose a topic"),
        value: user.topicOne,
        onChanged: (string) => setState(() => user.topicOne = string),
        items: _topicItems(),
      ),
    );
  }

  Widget topicSelectorTwo(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        hint: Text("Choose a topic"),
        value: user.topicTwo,
        onChanged: (string) => setState(() => user.topicTwo = string),
        items: _topicItems(),
      ),
    );
  }

  Widget topicSelectorThree(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        hint: Text("Choose a topic"),
        value: user.topicThree,
        onChanged: (string) => setState(() => user.topicThree = string),
        items: _topicItems(),
      ),
    );
  }

  Widget topicSelectorFour(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        hint: Text("Choose a topic"),
        value: user.topicFour,
        onChanged: (string) => setState(() => user.topicFour = string),
        items: _topicItems(),
      ),
    );
  }
  
  Widget topicSelectorFive(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton(
        hint: Text("Choose a topic"),
        value: user.topicFive,
        onChanged: (string) => setState(() => user.topicFive = string),
        items: _topicItems(),
      ),
    );
  }

  List<DropdownMenuItem> _topicItems (){
    List<DropdownMenuItem> items = List();
    for(String e in topics){
      items.add(
        new DropdownMenuItem(value: e, child: Text(e)),
      );
    }
    return items;
  }

  _getTopics() async {
    topics = await _repository.getTopics();
    setState(() {
    });
  }

  _getUser() async {
    user = await _repository.getUserDetails();
    setState(() {
    });
  }
}
