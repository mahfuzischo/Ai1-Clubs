import 'package:ai1_clubs/LUCC/newsFeed.dart';
import 'package:ai1_clubs/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:ai1_clubs/screens/events.dart';
import 'package:ai1_clubs/LUCC/lucc_album.dart';

class LUCC_Home extends StatefulWidget {
  const LUCC_Home({super.key});

  @override
  State<LUCC_Home> createState() => _LUCC_HomeState();
}

//feb 26
class _LUCC_HomeState extends State<LUCC_Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LUCC"),
        centerTitle: true,
        backgroundColor: Colors.grey[600],
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white70,
          ),
          onPressed: () async {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return home();
            }), (r) {
              return false;
            });
          },
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
            ),
            SizedBox(
              height: 70,
              width: 230,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FeedScreen()));
                },
                icon: Icon(
                  Icons.add,
                  size: 25,
                ),
                label: Text(
                  'Posts',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[500], // Background color
                  onPrimary: Colors.grey[400],

                  //splashFactory: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 70,
              width: 230,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => eventScreen()));
                },
                icon: Icon(
                  Icons.add,
                  size: 25,
                ),
                label: Text(
                  'Events',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[500], // Background color
                  onPrimary: Colors.grey[400],

                  //splashFactory: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 70,
              width: 230,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => lucc_album()));
                },
                icon: Icon(
                  Icons.photo_album,
                  size: 25,
                ),
                label: Text(
                  ' Album',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[500], // Background color
                  onPrimary: Colors.grey[400],

                  //splashFactory: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
