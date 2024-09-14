import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/createpost_item.dart';
import '../components/custom.snackbar.dart';
import '../constants/colors.dart';
import '../constants/data.dart';
import 'FacebookMockUpScreen.dart';



class CreatePost extends StatefulWidget {
  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String uid = "", name = "", imgurl = "", email = "";
  var _controlller = TextEditingController();
  var focausnode = FocusNode();
  var prefs;
  double fieldheight = 50;
  bool stretch = true,
      bgcolor = true,
      selectedbg = false,
      txtdark = true,expand1 = true, expand2 = true,
      processing = false;
  int bgnumber = 0;

  List<File> selectedImages = [];
  final picker = ImagePicker();
  double fontsize = 28;

  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("uid")!;
      name = prefs.getString("name")!;
      email = prefs.getString("email")!;
      imgurl = prefs.getString("usrimg")!;
    });
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
          () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
            bgcolor = false;
            selectedbg = false;
            bgnumber = 0;
            txtdark = true;
            FocusScope.of(context).requestFocus(focausnode);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  savedata() async {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length,
                (_) => _chars.codeUnitAt(
                _rnd.nextInt(_chars.length))));

    String postid = getRandomString(20);
    List<String> _downloadUrls = [];

    if (selectedImages.isNotEmpty) {
      await Future.forEach(selectedImages, (image) async {
        if (image is File) { // Ensure 'image' is a File
          List<String>? words = image.path.toString().split("/");
          Reference ref = FirebaseStorage.instance
              .ref("Documents/$postid/")
              .child(words[words.length - 1]);
          final UploadTask uploadTask = ref.putFile(image);
          final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
          final url = await taskSnapshot.ref.getDownloadURL();
          _downloadUrls.add(url);
        }
      });
    }
    FirebaseFirestore.instance.collection('Posts').doc(postid).set({
      'Full Name': name,
      'User ID': uid,
      'Like': 0,
      'Comment': 0,
      'Post ID':postid,
      'Time': DateTime.now(),
      'Usr Image':imgurl,
      'Images': _downloadUrls,
      'Text': _controlller.text,
      'Background Number': bgnumber,
    }).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => NewsFeedScreen()),
              (Route<dynamic> route) => false);
      SnackUtil.showSnackBar(
        context: context,
        text: "Posted Successfully",
        textColor: Colors.white,
        backgroundColor: Colors.green,
      );
    });

  }

  @override
  Widget build(BuildContext context) {

    Future<bool> _onBackPressed(BuildContext context) async {
      return (await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(title: const Text("Want to Finish Post Edit?"),
            actions: <Widget>[
              TextButton(

                onPressed: () {
                  Navigator.of(ctx).pop();},
                child: const Text("cancel",
                ),),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("discard",
                ),),
            ],
          ))) ?? false  ;

    }

    void _handleTextChange(String val) {
      setState(() {
        // Add your text length logic here
        if (val.length > 100) {
          fontsize = 16;
        } else if (val.length > 50) {
          fontsize = 22;
        } else {
          fontsize = 28;
        }
        selectedbg = val.length <= 50;
      });
    }

    void _handleBackgroundChange(int index) {
      setState(() {
        bgnumber = index;
        txtdark = index.isEven;
        selectedbg = index != 0;
      });
    }
    Widget _buildBackgroundSelector() {
      return !stretch && bgcolor
          ? Container(
        height: 35,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: background.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(focausnode);
                setState(() {
                  _handleBackgroundChange(index);
                });
              },
              child: Container(
                width: 35,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: AssetImage(background[index]),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      )
          : const SizedBox();
    }
    Widget _buildOptionButton({required String text, required Color color, required icon}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            icon is String
                ? Image.asset(icon, height: 12, width: 12)
                : Icon(icon, color: color, size: 16),
            const SizedBox(width: 5),
            Text(text, style: TextStyle(fontSize: 12, color: color)),
            Icon(Icons.arrow_drop_down_outlined, color: color, size: 16),
          ],
        ),
      );
    }

    Widget _buildImageTile(int index) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: FileImage(selectedImages[index]),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedImages.removeAt(index);
              if (selectedImages.isEmpty) {
                bgcolor = true;
              }
            });
          },
          child: const Icon(
            Icons.cancel_outlined,
            color: Colors.white,
          ),
        ),
      );
    }


    Widget _buildDivider() {
      return Container(
        width: double.infinity,
        height: 0.4,
        color: Colors.grey,
        margin: const EdgeInsets.only(top: 10),
      );
    }
    Widget _buildPostOption(String text, IconData icon, Color color, Function()? onTap) {
      return InkWell(
        onTap: onTap,
        child: CreatePostItem(
          cs: color,
          ist: icon,
          txt: text,
        ),
      );
    }
    Widget _buildPostOptions() {
      return Column(
        children: [
          _buildDivider(),
          _buildPostOption("Photo/Video", Icons.add_photo_alternate_outlined, Colors.green, getImages),
          _buildDivider(),
          _buildPostOption("Tag People", Icons.bookmark_border, Colors.blue, null),
          _buildDivider(),
          _buildPostOption("Feelings/Activity", Icons.tag_faces, Colors.orange, null),
          _buildDivider(),
          _buildPostOption("Check In", Icons.location_on_outlined, Colors.redAccent, null),
          _buildDivider(),
          bgcolor ? _buildPostOption("Live Video", Icons.video_call_outlined, Colors.red, null) : const SizedBox(),
          bgcolor ? _buildDivider() : const SizedBox(),
          bgcolor
              ? _buildPostOption("Background Colour", Icons.text_fields, Colors.cyanAccent, () {
            setState(() {
              stretch = false;
              FocusScope.of(context).requestFocus(focausnode);
            });
          })
              : const SizedBox(),
        ],
      );
    }




    return WillPopScope(
      onWillPop: (() => _onBackPressed(context)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              _onBackPressed(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: AppColors.creamColor,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  processing = true;
                });
                savedata();
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(0xff0023ff),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "POST",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            )
          ],
          title: const Text(
            "Create post",
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
        ),
        body: processing
            ? Container(
          color: Colors.white.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        )
            : Column(
          children: [
            Container(
              width: double.infinity,
              height: 0.4,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(imgurl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          _buildOptionButton(
                              icon: 'assets/world.png',
                              text: 'Public',
                              color: Colors.blue),
                          SizedBox(width: 10),
                          _buildOptionButton(
                              icon: Icons.add, text: 'Album', color: Colors.blue),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: selectedbg ? Alignment.center : Alignment.topLeft,
                height: selectedbg ? 250 : fieldheight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(background[bgnumber]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textAlign:
                  selectedbg ? TextAlign.center : TextAlign.start,
                  controller: _controlller,
                  onTap: () {
                    setState(() {
                      stretch = false;
                    });
                  },
                  onChanged: (val) {
                    _handleTextChange(val);
                  },
                  focusNode: focausnode,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "What's on your mind?",
                    filled: true,
                    fillColor: selectedbg
                        ? Colors.transparent
                        : Colors.grey.shade50,
                    hintStyle: TextStyle(
                        color: txtdark
                            ? Colors.black.withOpacity(0.5)
                            : Colors.white.withOpacity(0.8)),
                  ),
                  style: TextStyle(
                      fontSize: fontsize,
                      fontWeight: FontWeight.bold,
                      color: txtdark ? Colors.black : Colors.white),
                ),
              ),
            ),
            Expanded(
              child: selectedImages.isEmpty
                  ? const SizedBox()
                  : GridView.builder(
                padding: const EdgeInsets.all(6),
                itemCount: selectedImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  return _buildImageTile(index);
                },
              ),
            ),
            _buildBackgroundSelector(),
            stretch ? _buildPostOptions() : const SizedBox(),
          ],
        ),
      ),
    );

  }
}
