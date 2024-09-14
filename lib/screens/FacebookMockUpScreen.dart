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


  //
  // Future<void> _fetchQuestions() async {
  //   final QuerySnapshot result = await FirebaseFirestore.instance.collection('UserQuestion').get();
  //   final List<UserQuestion> questions = result.docs.map((doc) {
  //     int likes = 0;
  //     print(doc);
  //     if (doc.data().toString().contains('likes')) {
  //       likes = doc['likes'];
  //     }
  //     return UserQuestion(
  //       id: doc.id,
  //       name: doc['name'],
  //       email: doc['email'],
  //       mobile: doc['mobile'],
  //       question: doc['question'],
  //       imageUrl: doc['imageUrl'],
  //       likes: likes,
  //       likedByUser: false,
  //     );
  //   }).toList();
  //   setState(() {
  //     _questions = questions;
  //   });
  // }

  Future<void> _savePost() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('UserQuestion').add({
        'name': 'User Name', // Replace with the actual user's name
        'email': 'user@example.com', // Replace with the actual user's email
        'mobile': '123456789', // Replace with the actual user's mobile
        'question': _questionController.text,
        'imageUrl': _imageUrlController.text, // Image URL from user input
        'likes': 0,
      });
      _questionController.clear();
      _imageUrlController.clear();
    //  _fetchQuestions(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post created!')));
    }
  }

  // Existing methods for liking and commenting posts...

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
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
                                  border:
                                  Border.all(color: Colors.white, width: 2),
                                  image: DecorationImage(
                                      image:
                                      NetworkImage(imgs),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CreatePost()));
                                },
                                child: const TextField(
                                  enabled: false,
                                  decoration: InputDecoration.collapsed(
                                      hintText: 'What\'s on your mind?'),
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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "Stories",
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 1.2),
                      ),
                      const Text("See Archive"),
                    ],
                  ),
                ),
                Container(
                  height: 180,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      makeStory(
                          storyImage: 'assets/story/story-1.jpg',
                          userImage: 'assets/aatik-tasneem.jpg',
                          userName: 'Aatik Tasneem'),
                      makeStory(
                          storyImage: 'assets/story/story-3.jpg',
                          userImage: 'assets/aiony-haust.jpg',
                          userName: 'Aiony Haust'),
                      makeStory(
                          storyImage: 'assets/story/story-4.jpg',
                          userImage: 'assets/averie-woodard.jpg',
                          userName: 'Averie Woodard'),
                      makeStory(
                          storyImage: 'assets/story/story-5.jpg',
                          userImage: 'assets/azamat-zhanisov.jpg',
                          userName: 'Azamat Zhanisov'),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Posts')
                      .orderBy("Time", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              Post pst =
                              Post.fromJson(snapshot.data!.docs[index]);
                              return makeFeed(usrimg: imgs,
                                pst: pst, uid: uid, uname: name,);

                            }),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  // Widget _buildQuestionCard(UserQuestion question) {
  //   final Color randomColor = Color.fromARGB(
  //     255,
  //     Random().nextInt(256),
  //     Random().nextInt(256),
  //     Random().nextInt(256),
  //   );
  //
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Card(
  //       color: randomColor.withOpacity(0.1),
  //       child: Container(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('Name: ${question.name}', style: TextStyle(fontWeight: FontWeight.bold)),
  //             SizedBox(height: 8.0),
  //             Text('Question: ${question.question}'),
  //             if (question.imageUrl != null && question.imageUrl.isNotEmpty)
  //               Image.network(question.imageUrl), // Display the image
  //             SizedBox(height: 8.0),
  //             _buildActionButtons(question), // Facebook-like action buttons
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Future<void> _toggleLike(UserQuestion question) async {
  //   setState(() {
  //     if (question.likedByUser) {
  //       question.likes--;
  //       question.likedByUser = false;
  //     } else {
  //       question.likes++;
  //       question.likedByUser = true;
  //     }
  //   });
  //
  //   // Update Firestore
  //   await FirebaseFirestore.instance.collection('UserQuestion').doc(question.id).update({
  //     'likes': question.likes,
  //   });
  //
  //   // Update SharedPreferences
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('liked_${question.id}', question.likedByUser);
  // }

  Future<void> _addComment(String questionId, String comment) async {
    await FirebaseFirestore.instance.collection('UserQuestion').doc(questionId).collection('Comments').add({
      'comment': comment,
      'timestamp': Timestamp.now(),
    });
  }

  void _showCommentsBottomSheet(BuildContext context, String questionId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('UserQuestion')
              .doc(questionId)
              .collection('Comments')
              .orderBy('timestamp', descending: true)
              .get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print(snapshot.error);
            if (!snapshot.hasData) {
              return Center(child: SpinKitDancingSquare(color: Colors.blue));
            }

            final comments = snapshot.data!.docs;

            bool isKeyboard = MediaQuery.of(context).viewInsets.bottom > 0;
            print(isKeyboard);
            return Column(
              children: [
                if (!isKeyboard)
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(comments[index]['comment']),
                          subtitle: Text(comments[index]['timestamp'].toDate().toString()),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildCommentInputField(questionId),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCommentInputField(String questionId) {
    TextEditingController _commentController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: "Add a comment..."),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            _addComment(questionId, _commentController.text);
            _commentController.clear();
          },
        ),
      ],
    );
  }

  // Widget _buildActionButtons(UserQuestion question) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Row(
  //         children: [
  //           IconButton(
  //             icon: Icon(
  //               question.likedByUser ? Icons.thumb_up : Icons.thumb_up_off_alt,
  //               color: question.likedByUser ? Colors.blue : Colors.grey,
  //             ),
  //             onPressed: () => _toggleLike(question),
  //           ),
  //           Text('${question.likes}'),
  //         ],
  //       ),
  //       TextButton(
  //         onPressed: () {
  //           _showCommentsBottomSheet(context, question.id);
  //         },
  //         child: Row(
  //           children: [
  //             Icon(Icons.comment, color: Colors.grey),
  //             SizedBox(width: 4.0),
  //             Text('Comment', style: TextStyle(color: Colors.grey)),
  //           ],
  //         ),
  //       ),
  //       TextButton(
  //         onPressed: () {
  //           Share.share("Name: ${question.name}, Question: ${question.question}");
  //         },
  //         child: Row(
  //           children: [
  //             Icon(Icons.share, color: Colors.grey),
  //             SizedBox(width: 4.0),
  //             Text('Share', style: TextStyle(color: Colors.grey)),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

// Existing methods for _toggleLike, _showCommentsBottomSheet...
}
