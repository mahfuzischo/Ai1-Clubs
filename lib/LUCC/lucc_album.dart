import 'package:ai1_clubs/screens/registration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class lucc_album extends StatefulWidget {
  const lucc_album({super.key});

  @override
  State<lucc_album> createState() => _lucc_albumState();
}

class _lucc_albumState extends State<lucc_album> with TickerProviderStateMixin {
  Future<void> refresh() async {
    return await Future.delayed(Duration(seconds: 8));
  }

  void initState() {
    // controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 8),
    // )..addListener(() {
    //     setState(() {});
    //   });
    // controller.repeat(reverse: true);
    super.initState();
  }

  final imagePicker = ImagePicker();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  File? _image;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int x = 0;
  int y = 0;

  int a = 1;

  List<Image> lucc_imgList = [];

  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<int> _listFiles() async {
    int x = 0;
    final storageRef = FirebaseStorage.instance.ref("lucc_album/");
    final listResult = await storageRef.listAll();
    String ss = listResult.toString();
    print('List result: $listResult');
    for (var item in listResult.items) {
      if (item != null) {
        x++;
      }
    }
    print("Number of pics : $x");
    return x;
  }

  Future<String> _uploadImg(File file) async {
    int g = await _listFiles();
    int k = g + 1;
    String _picname = "LUCCimage$k";
    Reference ref = _storage.ref().child("lucc_album").child(_picname);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snap = await uploadTask;
    String dldURL = await snap.ref.getDownloadURL().toString();
    print("photourl:     " + dldURL);
    return dldURL;
  }

  Future<String> _uploadImgUrl(File img) async {
    // String s = "Failed";
    String photoid = Uuid().v1();
    String x = await _uploadImg(img);
    print(x.toString());
    await fire.collection('luccAlbum').doc(photoid).set({"photoURL": x});
    return x;
  }

  late AnimationController controller;

  @override
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
                final image =
                    await imagePicker.getImage(source: ImageSource.gallery);
                setState(() {
                  if (image != null) {
                    _image = File(image.path);
                  } else
                    ShowSnackBarText("No image selected");
                });
                _uploadImgUrl(_image!);
              },
            ),
          ],
          backgroundColor: Colors.purple[300],
          elevation: 0,
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('luccAlbum')
              .where('photoURL', isNotEqualTo: null)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              itemCount: (snapshot.data! as dynamic).docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                //childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                return Container(
                  child: Image(
                    image: NetworkImage(snap['photoURL']),
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          },
        )

        // LiquidPullToRefresh(
        //   animSpeedFactor: 5,
        //   child: gg(),
        //   onRefresh: refresh,
        //   height: 250,
        //   backgroundColor: Colors.purple[300],
        //   color: Colors.orange[200],
        //   showChildOpacityTransition: true,
        // )
        /*Column(
          children: [
            
            if (lucc_imgList.length != 0) ...[
              getWidget()
            ] else ...[
              Center(
                child: CircularProgressIndicator(
                  value: controller.value,
                  semanticsLabel: 'Circular progress indicator',
                ),
              )
            ]
          ],
        )*/
        /*RefreshIndicator(
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
    _listFiles();
    print('URL : ');
    // print(downloadURL('1'));

    // lucc_images();
    //lucc_print();
    //pushImg();

    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [...lucc_imgList],
    );

    //  return Text('Fuck you!!!');
  }
}
