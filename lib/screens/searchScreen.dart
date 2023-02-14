import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ai1_clubs/screens/profile.dart';
import 'package:ai1_clubs/LUCC/postWidget.dart';
import 'package:ai1_clubs/LUCC/newsFeed.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool showPosts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white70,
          ),
          onPressed: () async {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => FeedScreen()));
          },
        ),
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(labelText: 'Search posts'),
            onFieldSubmitted: (String _) {
              setState(() {
                showPosts = true;
              });
              print(_);
            },
          ),
        ),
      ),
      body: showPosts
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .where(
                    'description',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => postWidget(
                            snap: (snapshot.data! as dynamic).docs[index]
                                ['postId'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: (snapshot.data! as dynamic).docs[index]
                                      ['username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey)),
                              TextSpan(
                                  text: (snapshot.data! as dynamic).docs[index]
                                      ['description'],
                                  style: TextStyle(color: Colors.grey[800])),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Container(
              child: Center(child: Text("Search for posts.....")),
            ),
    );
  }
}
