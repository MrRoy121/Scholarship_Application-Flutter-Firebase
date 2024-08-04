import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      if (_currentPage < _questions.length) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  Future<void> _fetchQuestions() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('UserQuestion').get();
    final List<UserQuestion> questions = result.docs
        .map((doc) => UserQuestion(
              name: doc['name'],
              email: doc['email'],
              mobile: doc['mobile'],
              question: doc['question'],
            ))
        .toList();

    _questions = questions;

      setState(() {
      });

  }

  @override
  Widget build(BuildContext context) {
    return _questions.isEmpty
      ? Center(child: SpinKitDancingSquare(color: Colors.blue,))
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name: ${question.name}'),
                  Text('Email: ${question.email}'),
                ],
              ),
              Text('Mobile: ${question.mobile}'),
              Text('Question: ${question.question}'),
            ],
          ),
        ),
      ),
    );
  }
}
