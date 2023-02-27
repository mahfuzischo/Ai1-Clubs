import 'package:ai1_clubs/screens/requestJoin.dart';
import 'package:ai1_clubs/screens/requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai1_clubs/screens/log_in.dart';
import 'package:ai1_clubs/LUCC/lucc_home.dart';
import 'package:provider/provider.dart';
import 'package:ai1_clubs/provider.dart';
import 'package:ai1_clubs/screens/profile.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

bool isAdmin = false;
bool isLuccUser = false;
bool isRestricted = false;

class _homeState extends State<home> {
  Future<String> getAdmin() async {
    dynamic uid = FirebaseAuth.instance.currentUser!.uid.toString();
    String uname = '';
    var collection = FirebaseFirestore.instance.collection('admins');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      var value = data['uid'].toString().trim();
      if (uid == value) {
        isAdmin = true;
      }

      uname = value;
      print(uid);
      print(uname);
    }
    return uname;
  }

  Future<String> getLuccUser() async {
    dynamic uid = FirebaseAuth.instance.currentUser!.uid.toString();
    String uname = '';
    var collection = FirebaseFirestore.instance.collection('usersLucc');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      print("Exists");
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      var value = data['uid'].toString().trim();
      if (uid == value) {
        isLuccUser = true;
      }

      uname = value;
      print(uid);
      print(uname);
    }
    return uname;
  }

  // Future<String> getRestriction() async {
  //   dynamic uid = FirebaseAuth.instance.currentUser!.uid.toString();
  //   String uname = '';
  //   var collection = FirebaseFirestore.instance.collection('restricted');
  //   var docSnapshot = await collection.doc(uid).get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
  //     var value = data['uid'].toString();
  //     if (uid == value) {
  //       isRestricted = true;
  //       print("Restricted:" + uid);
  //     }

  //     uname = value;
  //   }
  //   return uname;
  // }

  @override
  void initState() {
    super.initState();
    addData();
    getAdmin();
    getLuccUser();
  }

  addData() async {
    provider _userProvider = Provider.of<provider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          backgroundColor: Colors.grey[700],
          centerTitle: true,
          title: Text(
            'Home',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          leading: isAdmin == true
              ? PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("Join Requests"),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Profile"),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => requests()));
                    }
                    if (value == 1) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => profile()));
                    }
                  },
                )
              : CircleAvatar(
                  backgroundColor: Colors.grey[500],
                  radius: 8,
                  child: IconButton(
                    icon: Icon(
                      size: 30,
                      Icons.person_sharp,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => profile()));
                    },
                  ),
                ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Are you sure you want to log out?"),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(context);
                              },
                              child: Text("Cancel")),
                          ElevatedButton(
                              onPressed: () async {
                                if (FirebaseAuth.instance.currentUser == null) {
                                  ShowSnackBarText("Already logged out");
                                } else {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return logIn();
                                  }), (r) {
                                    return false;
                                  });
                                }
                              },
                              child: Text("Yes"))
                        ],
                      );
                    });
              },
            )
          ]),
      body: Container(
        padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
        child: GridView(
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {
                    if (isLuccUser == true) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LUCC_Home()));
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => requestJoin()));
                    }
                  },
                  splashColor: Colors.blue,
                  child: Ink.image(
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      image: AssetImage('images/lucc1.jpg')),
                ),
              ),
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {},
                  splashColor: Colors.blue,
                  child: Ink.image(
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      image: AssetImage('images/lusc.jpg')),
                ),
              ),
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (context) => LUCC_Home()));
                  },
                  splashColor: Colors.blue,
                  child: Ink.image(
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      image: AssetImage('images/bannedCommunity.jpg')),
                ),
              ),
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {},
                  splashColor: Colors.blue,
                  child: Ink.image(
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      image: AssetImage('images/a1.jpg')),
                ),
              ),
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {},
                  splashColor: Colors.blue,
                  child: Ink.image(
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      image: AssetImage('images/a2.jpg')),
                ),
              ),
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {},
                  splashColor: Colors.blue,
                  child: Ink.image(
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      image: AssetImage('images/a3.jpg')),
                ),
              ),
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {},
                  splashColor: Colors.blue,
                  child: Ink.image(
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      image: AssetImage('images/a4.jpg')),
                ),
              ),
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {},
                  splashColor: Colors.blue,
                  child: Ink.image(
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      image: AssetImage('images/a5.jpg')),
                ),
              ),
            )
          ],
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 0, crossAxisSpacing: 0),
        ),
      ),
    );
  }
}
