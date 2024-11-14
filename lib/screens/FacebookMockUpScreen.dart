import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';
import '../components/makefeed.dart';
import '../components/makestory.dart';
import '../models/postModel.dart';
import 'create_post_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController(); // For image URL
  // List<UserQuestion> _questions = [];
  String uid = "", name = "", imgs = "";

  @override
  void initState() {
    sharedPref();
    super.initState();
    //_fetchQuestions();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("uid")!;
      name = prefs.getString("name")!;
      imgs = prefs.getString("usrimg")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: const Text(
          'Scholarships',
          style: TextStyle(color: Colors.blue, fontSize: 25.0, fontWeight: FontWeight.bold, letterSpacing: -1.2),
        ),
        centerTitle: false,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CreatePost()));
            },
            child: Container(
              width: 35,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey.shade300),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          Container(
            width: 35,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey.shade300),
            child: Icon(
              Icons.search_rounded,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 3,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                image: DecorationImage(image: NetworkImage(imgs), fit: BoxFit.cover)),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (BuildContext context) => CreatePost()));
                              },
                              child: const TextField(
                                enabled: false,
                                decoration: InputDecoration.collapsed(
                                    hintText: 'What\'s on your mind?', hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 10.0, thickness: 0.5),
                      SizedBox(
                        height: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: () => print('Live'),
                              icon: const Icon(
                                Icons.videocam,
                                color: Colors.red,
                              ),
                              label: const Text('Live'),
                            ),
                            const VerticalDivider(width: 8.0),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.photo_library,
                                color: Colors.green,
                              ),
                              label: const Text('Photo'),
                            ),
                            const VerticalDivider(width: 8.0),
                            TextButton.icon(
                              onPressed: () => print('Room'),
                              icon: const Icon(
                                Icons.video_call,
                                color: Colors.purpleAccent,
                              ),
                              label: const Text('Room'),
                            ),
                            const VerticalDivider(width: 8.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.baseline,
              //     textBaseline: TextBaseline.alphabetic,
              //     children: [
              //       Text(
              //         "Stories",
              //         style: TextStyle(
              //             color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 1.2),
              //       ),
              //       const Text("See Archive"),
              //     ],
              //   ),
              // ),
              // Container(
              //   height: 180,
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       makeStory(
              //           storyImage: 'assets/story/story-1.jpg',
              //           userImage: 'assets/aatik-tasneem.jpg',
              //           userName: 'Aatik Tasneem'),
              //       makeStory(
              //           storyImage: 'assets/story/story-3.jpg',
              //           userImage: 'assets/aiony-haust.jpg',
              //           userName: 'Aiony Haust'),
              //       makeStory(
              //           storyImage: 'assets/story/story-4.jpg',
              //           userImage: 'assets/averie-woodard.jpg',
              //           userName: 'Averie Woodard'),
              //       makeStory(
              //           storyImage: 'assets/story/story-5.jpg',
              //           userImage: 'assets/azamat-zhanisov.jpg',
              //           userName: 'Azamat Zhanisov'),
              //     ],
              //   ),
              // ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Posts').orderBy("Time", descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isNotEmpty) {

                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          print("snapshot.data!.docs.!@#$index");
                          print(snapshot.data!.docs.length);
                          print(snapshot.data!.docs.length);
                          print("snapshot.data!.docs.length");
                          Post pst = Post.fromJson(snapshot.data!.docs[index]);
                          return makeFeed(
                            usrimg: imgs,
                            pst: pst,
                            uid: uid,
                            uname: name,
                          );
                        },
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
