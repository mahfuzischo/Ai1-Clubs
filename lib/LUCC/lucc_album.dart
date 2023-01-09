import 'dart:io';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';

class lucc_album extends StatefulWidget {
  const lucc_album({super.key});

  @override
  State<lucc_album> createState() => _lucc_albumState();
}

class _lucc_albumState extends State<lucc_album> {
  final storage = FirebaseStorage.instance;
  int x = 0;
  int y = 0;
  List<Image> myImages = [
    Image(
      image: AssetImage('images/lulogo1.jpg'),
      fit: BoxFit.cover,
    ),
  ];

  int a = 1;
  //List<String> imge = [];
  List<Image> lucc_imgList = [];

  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  listFiles() async {
    final storageRef = FirebaseStorage.instance.ref("lucc_album/");
    final listResult = await storageRef.listAll();
    String ss = listResult.toString();
    print('List result: $listResult');
    for (var item in listResult.items) {
      if (item != null) {
        x++;
      }
    }
    y = x;
  }

  /* Future<void> _reload(bool reload) async {
    await getWidget().;
  }*/

  void initState() {
    super.initState();
    // _reload(true);
  }

  Future<void> uploadFile(String filepath, String filename) async {
    File file = File(filepath);
    int z = x + 1;
    try {
      await storage.ref('lucc_album/lucc_img$z)').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future downloadURL(String imgName) async {
    String c = imgName.toString();
    String dowloadURL =
        await storage.ref('lucc_album/lucc_img$c.jpg').getDownloadURL();
    return dowloadURL;
  }

  /*lucc_images() async {
    for (var i = 0; i <= x; i++) {
      imge.add(await downloadURL("$i"));
    }
  }*/

  /* lucc_print() {
    for (var i = 0; i <= x; i++) {
      print(imge.toString());
    }
  }
*/
  pushImg() async {
    for (var i = 0; i < x; i++) {
      String s = 'lucc_album/lucc_img$i.jpg';
      print(s);
      /*  final List<Image> myImages = [
        Image(
          image: NetworkImage(
              await storage.ref('lucc_album/lucc_img$s.jpg').getDownloadURL()),
          fit: BoxFit.cover,
        ),
      ];*/

      lucc_imgList.add(Image(
        image: NetworkImage(
          await storage.ref('lucc_album/lucc_img1.jpg').getDownloadURL(),
        ),
        fit: BoxFit.cover,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LUCC Album"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.white70,
              ),
              onPressed: () async {
                print(x);
                int n = x;
                final _res = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg', 'jpeg']);
                if (_res == null) {
                  ShowSnackBarText('No file found!');
                  return null;
                }
                final path = _res.files.single.path!;
                final fileName = _res.files.single.name;

                uploadFile(path, fileName);
              },
            ),
          ],
          backgroundColor: Colors.purple[300],
          elevation: 0,
        ),
        body:
            getWidget() /*RefreshIndicator(
            onRefresh: () async {
              getWidget();
            },
            child: gg())*/

        /*FutureBuilder(
          future: storage.ref('lucc_album/lucc_img1.jpg').getDownloadURL(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print('object');
              } else if (snapshot.hasData) {
                return Container(
                    width: 300,
                    height: 250,
                    child: Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ));
              }
            } else {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                child: Text('Fuck you!!!!!'),
              );
            }
            return Container(
              child: Text('Fuck you  again!!!!!'),
            );
          }),*/
        );
  }

  Widget gg() {
    return getWidget();
  }

  Widget getWidget() {
    print(x);
    listFiles();
    print('URL : ');
    print(downloadURL('1'));
    if (x > 0) {
      // lucc_images();
      //lucc_print();
      pushImg();

      return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: [...lucc_imgList],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
    return Text('Fuck you!!!');
  }
}
