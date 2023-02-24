// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:ai1_clubs/userData.dart' as model;
// import 'package:provider/provider.dart';
// import 'package:ai1_clubs/methods.dart';

// import '../userData.dart';

// class adminPanel extends StatefulWidget {
//   const adminPanel({super.key});

//   @override
//   State<adminPanel> createState() => _adminPanelState();
// }

// class _adminPanelState extends State<adminPanel> {
//   void ShowSnackBarText(String text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         duration: Duration(seconds: 3),
//         content: Text(text),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin '),
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.black54,
//       body: SingleChildScrollView(
//         child: Container(
//             child: FutureBuilder(
//           future: FirebaseFirestore.instance
//               .collection("Users")
//               .where('uid', isNotEqualTo: null)
//               .get(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               if (snapshot.hasData) {
//                 return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: (snapshot.data! as dynamic).docs.length,
//                     itemBuilder: ((context, index) {
//                       DocumentSnapshot snap =
//                           (snapshot.data! as dynamic).docs[index];
//                       return Column(
//                         children: [
//                           ListTile(
//                             iconColor: Colors.blue,
//                             tileColor: Colors.blue.withOpacity(0.2),
//                             leading: CircleAvatar(
//                               backgroundImage: NetworkImage(snap['photoURL']),
//                             ),
//                             title: Text("Name: " + snap['userName']),
//                             subtitle: Column(
//                               children: [
//                                 Text("Student ID: " + snap['student_id']),
//                                 Text("Email: " + snap['email'])
//                               ],
//                             ),
                            
//                           ),
//                           Dialog(
//                                 child: PopupMenuButton(
//                                   itemBuilder: (context) {
//                                     return [
//                                       PopupMenuItem<int>(
//                                         value: 0,
//                                         child: Text("Delete"),
//                                       ),
//                                       PopupMenuItem<int>(
//                                         value: 1,
//                                         child: Text("Edit"),
//                                       ),
//                                     ];
//                                   },
//                                   onSelected: (value) {
//                                     if (value == 0) {
//                                       deletePost(
//                                         widget.snap['postId'].toString(),
//                                       );

//                                       Navigator.of(context).pop();
//                                     }
//                                     if (value == 1) {
//                                       Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                           builder: (context) => editPost(
//                                             reqID:  widget.snap['postId']
//                                                 .toString(),
                                            
//                                           ),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                 ),
//                          ],
//                       );
//                     }));
//               }
//             } else
//               ShowSnackBarText("NO Users");
//           },
//         )),
//       ),
//     );
//   }
// }
