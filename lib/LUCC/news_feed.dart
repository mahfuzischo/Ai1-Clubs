// import 'package:ai1_clubs/LUCC/addPost.dart';
// import 'package:flutter/material.dart';
// import 'package:ai1_clubs/LUCC/add_post.dart';
// import 'package:flutter/rendering.dart';

// class newsFeed extends StatefulWidget {
//   const newsFeed({super.key});

//   @override
//   State<newsFeed> createState() => _newsFeedState();
// }

// class _newsFeedState extends State<newsFeed> {
//   String netPic = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//           AppBar(title: Text('News Feed'), centerTitle: true, actions: <Widget>[
//         IconButton(
//           icon: Icon(
//             Icons.post_add_outlined,
//             color: Colors.white70,
//           ),
//           onPressed: () async {
//             Navigator.of(context)
//                 .push(MaterialPageRoute(builder: (context) => addPost()));
//           },
//         ),
//       ]),
//       body: Column(
//         children: <Widget>[
//           Card(
//             child: Container(
//                 height: 360,
//                 color: Colors.blue[55],
//                 child: Column(
//                   children: <Widget>[
//                     ListTile(
//                       leading: CircleAvatar(),
//                       title: Text('Profile name'),
//                       subtitle: Text('Date and Time'),
//                     ),
//                     Expanded(
//                         child: Container(
//                       decoration: BoxDecoration(
//                           // color: Colors.blueAccent,
//                           shape: BoxShape.rectangle,
//                           border: Border.all(
//                               color: Colors.blueAccent,
//                               style: BorderStyle.solid,
//                               width: 5),
//                           image: DecorationImage(
//                               image: netPic != null
//                                   ? AssetImage('images/lulogo1.jpg')
//                                   : NetworkImage(
//                                           'data:image/png;base64,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')
//                                       as ImageProvider)),
//                     )),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       children: <Widget>[
//                         SizedBox(
//                           width: 130,
//                         ),
//                         Icon(
//                           Icons.comment,
//                           color: Colors.blueGrey,
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Text('Comments')
//                       ],
//                     ),
//                     SizedBox(
//                       height: 15,
//                     )
//                   ],
//                 )),
//           )
//         ],
//       ),
//     );
//   }
// }
