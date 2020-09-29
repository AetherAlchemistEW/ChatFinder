class User {
  String uid;
  //String name;
  //String email;
  String username;
  //String status; // ?
  //int state; // ?
  String profilePhoto;
  String topicOne;
  String topicTwo;
  String topicThree;
  String topicFour;
  String topicFive;

  User({
    this.uid,
    //this.name,
    //this.email,
    this.username,
    //this.status,
    //this.state,
    this.profilePhoto,
    this.topicOne,
    this.topicTwo,
    this.topicThree,
    this.topicFour,
    this.topicFive,
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    //data['name'] = user.name;
    //data['email'] = user.email;
    data['username'] = user.username;
    //data["status"] = user.status;
    //data["state"] = user.state;
    data["profile_photo"] = user.profilePhoto;
    data["topic_one"] = user.topicOne;
    data["topic_two"] = user.topicTwo;
    data["topic_three"] = user.topicThree;
    data["topic_four"] = user.topicFour;
    data["topic_five"] = user.topicFive;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    //this.name = mapData['name'];
    //this.email = mapData['email'];
    this.username = mapData['username'];
    //this.status = mapData['status'];
    //this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
    this.topicOne = mapData["topic_one"];
    this.topicTwo = mapData["topic_two"];
    this.topicThree = mapData["topic_three"];
    this.topicFour = mapData["topic_four"];
    this.topicFive = mapData["topic_five"];
  }
}