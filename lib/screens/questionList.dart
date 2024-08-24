import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

import '../models/user_questions.dart';

class QuestionList extends StatefulWidget {
  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  List<UserQuestion> _questions = [];
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('UserQuestion').get();
    final List<UserQuestion> questions = result.docs.map((doc) {
      int likes = 0;
      print(doc);
      if (doc.data().toString().contains('likes')) {
        likes = doc['likes'];
      }
      return UserQuestion(
        id: doc.id,
        name: doc['name'],
        email: doc['email'],
        mobile: doc['mobile'],
        question: doc['question'],
        likes: likes,
        likedByUser: false,
      );
    }).toList();

    _questions = questions;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var question in _questions) {
      question.likedByUser = prefs.getBool('liked_${question.id}') ?? false;
      setState(() {});
    }
  }

  Future<void> _toggleLike(UserQuestion question) async {
    setState(() {
      if (question.likedByUser) {
        question.likes--;
        question.likedByUser = false;
      } else {
        question.likes++;
        question.likedByUser = true;
      }
    });

    // Update Firestore
    await FirebaseFirestore.instance.collection('UserQuestion').doc(question.id).update({
      'likes': question.likes,
    });

    // Update SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('liked_${question.id}', question.likedByUser);
  }

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

  @override
  Widget build(BuildContext context) {
    return _questions.isEmpty
        ? Center(
            child: SpinKitDancingSquare(
            color: Colors.blue,
          ))
        : PageView.builder(
            controller: _pageController,
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              return _buildQuestionCard(_questions[index]);
            },
          );
  }

  Widget _buildQuestionCard(UserQuestion question) {
    final Color randomColor = Color.fromARGB(
      255,
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: randomColor.withOpacity(0.1),
        shadowColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name: ${question.name}', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Email: ${question.email}'),
                ],
              ),
              const SizedBox(height: 8.0),
              Text('Mobile: ${question.mobile}'),
              const SizedBox(height: 8.0),
              Text('Question: ${question.question}', style: TextStyle(fontSize: 16.0)),
              const SizedBox(height: 16.0),
              _buildActionButtons(question), // Facebook-like action buttons
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(UserQuestion question) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                question.likedByUser ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                color: question.likedByUser ? Colors.blue : Colors.grey,
              ),
              onPressed: () => _toggleLike(question),
            ),
            Text('${question.likes}'),
          ],
        ),
        TextButton(
          onPressed: () {
            _showCommentsBottomSheet(context, question.id);
          },
          child: Row(
            children: [
              Icon(Icons.comment, color: Colors.grey),
              const SizedBox(width: 4.0),
              Text('Comment', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            Share.share("Name :${question.name}, Question :${question.question}");
          },
          child: Row(
            children: [
              Icon(Icons.share, color: Colors.grey),
              const SizedBox(width: 4.0),
              Text('Share', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
