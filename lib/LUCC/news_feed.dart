import 'package:flutter/material.dart';

class newsFeed extends StatefulWidget {
  const newsFeed({super.key});

  @override
  State<newsFeed> createState() => _newsFeedState();
}

class _newsFeedState extends State<newsFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('News Feed'), centerTitle: true, actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.post_add_outlined,
            color: Colors.white70,
          ),
          onPressed: () async {},
        ),
      ]),
      body: Column(
        children: <Widget>[
          Card(
            child: Container(
                height: 360,
                color: Colors.blue[55],
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(),
                      title: Text('Profile name'),
                      subtitle: Text('Date and Time'),
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://www.google.com/imgres?imgurl=https%3A%2F%2Flookaside.fbsbx.com%2Flookaside%2Fcrawler%2Fmedia%2F%3Fmedia_id%3D174903441724874&imgrefurl=https%3A%2F%2Fwww.facebook.com%2Fleadinguniversity2001%2Fvideos%2Fadmission-going-on-spring-2021%2F724029931838261%2F&tbnid=7vRSOmplib9eFM&vet=12ahUKEwjwpuiGssL8AhV19nMBHW0SBWgQMygeegUIARCiAg..i&docid=hicEbV8Ec_evuM&w=915&h=506&itg=1&q=leading%20university&client=firefox-b-d&ved=2ahUKEwjwpuiGssL8AhV19nMBHW0SBWgQMygeegUIARCiAg'))),
                      color: Colors.green[100],
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.comment,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(
                          width: 200,
                        ),
                        Text('Comments')
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
