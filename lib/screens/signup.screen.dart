import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import 'login.screen.dart';

class SignUpScreen extends StatefulWidget {
  final Color backgroundColor;
  final Color primaryColor;
  final AssetImage backgroundImage;

  SignUpScreen({
    Key? key,
    this.primaryColor = Colors.green,
    this.backgroundColor = Colors.white,
    this.backgroundImage = const AssetImage("assets/full-bloom.png"),
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isloading = false;
  final TextEditingController _conuserEmail = TextEditingController();
  final TextEditingController _conuserName = TextEditingController();
  final TextEditingController _conuserPass = TextEditingController();
  final TextEditingController _conuserPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: new Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: this.widget.backgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: new ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                            image: this.widget.backgroundImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 100.0, bottom: 10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Scholarships News',
                              style: TextStyle(
                                  fontSize: 30.0, color: Color(0xffFCAF38)),
                            ),
                            Text(
                              "Register Screen",
                              style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff50A3A4)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Full Name",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
                            Icons.abc,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          height: 30.0,
                          width: 1.0,
                          color: Colors.grey.withOpacity(0.5),
                          margin:
                              const EdgeInsets.only(left: 00.0, right: 10.0),
                        ),
                        new Expanded(
                          child: TextField(
                            controller: _conuserName,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your full name',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Mobile Number",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          height: 30.0,
                          width: 1.0,
                          color: Colors.grey.withOpacity(0.5),
                          margin:
                              const EdgeInsets.only(left: 00.0, right: 10.0),
                        ),
                        new Expanded(
                          child: TextField(
                            controller: _conuserPhone,
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your mobile number',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Email",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          height: 30.0,
                          width: 1.0,
                          color: Colors.grey.withOpacity(0.5),
                          margin:
                              const EdgeInsets.only(left: 00.0, right: 10.0),
                        ),
                        new Expanded(
                          child: TextField(
                            controller: _conuserEmail,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Password",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
                            Icons.lock_open,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          height: 30.0,
                          width: 1.0,
                          color: Colors.grey.withOpacity(0.5),
                          margin:
                              const EdgeInsets.only(left: 00.0, right: 10.0),
                        ),
                        new Expanded(
                          child: TextField(
                            controller: _conuserPass,
                            obscureText: true,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  isloading
                      ? Container(
                          child: SpinKitPouringHourGlassRefined(
                            color: widget.primaryColor,
                            size: 24,
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        widget.primaryColor, // Replaces `color`
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30.0), // Replaces `shape`
                                    ),
                                    splashFactory: InkSplash
                                        .splashFactory, // Default splash effect
                                  ),
                                  child: new Row(
                                    children: <Widget>[
                                      new Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          "Register",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      new Expanded(
                                        child: Container(),
                                      ),
                                      new Transform.translate(
                                        offset: Offset(15.0, 0.0),
                                        child: new Container(
                                          padding: const EdgeInsets.all(5.0),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors
                                                    .white, // Replaces `color`
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28.0), // Replaces `shape`
                                                ),
                                                shadowColor: Colors.white),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: this.widget.primaryColor,
                                            ),
                                            onPressed: () {
                                              signUp(context: context);
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    signUp(context: context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              alignment: Alignment.center,
                              child: Text(
                                "ALREADY HAVE AN ACCOUNT?",
                                style:
                                    TextStyle(color: this.widget.primaryColor),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginScreen()),
                                  (Route<dynamic> route) => false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 70,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 24,
                  color: AppColors.creamColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  signUp({required BuildContext context}) async {
    setState(() {
      isloading = true;
    });
    String email = _conuserEmail.text;
    String name = _conuserName.text;
    String pass = _conuserPass.text;
    String phone = _conuserPhone.text;

    if (email.isEmpty) {
      setState(() {
        isloading = false;
      });
      SnackUtil.showSnackBar(
        context: context,
        text: "Email is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (name.isEmpty) {
      setState(() {
        isloading = false;
      });
      SnackUtil.showSnackBar(
        context: context,
        text: "Name Is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (pass.isEmpty) {
      setState(() {
        isloading = false;
      });
      SnackUtil.showSnackBar(
        context: context,
        text: "Password is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (phone.isEmpty) {
      setState(() {
        isloading = false;
      });
      SnackUtil.showSnackBar(
        context: context,
        text: "Phone Number is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (pass.length < 6) {
      setState(() {
        isloading = false;
      });
      SnackUtil.showSnackBar(
        context: context,
        text: "Password Must Be 6 Digit or Character.",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else {
      try {
        String usrimg =
            "https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(1).jpg?alt=media&token=e14ab717-c75d-45b9-947c-2602f7916389&_gl=1*1tj7s46*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5MzE5LjYwLjAuMA..";
        var code = Random().nextInt(9) + 0;
        if (code == 1) {
          usrimg =
              "https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(2).jpg?alt=media&token=7b9dcc38-de3f-42b1-96b6-96713fb93eaa&_gl=1*1216kri*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NjUxLjU2LjAuMA..";
        } else if (code == 2) {
          usrimg =
              "https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(3).jpg?alt=media&token=473010a8-79ca-496d-8de8-d0870c7435a4&_gl=1*1ktyceo*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NjY1LjQyLjAuMA..";
        } else if (code == 3) {
          usrimg =
              "https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(4).jpg?alt=media&token=689c1dcc-9c6d-4465-b7f1-9a0bbdbb0f8b&_gl=1*d4v8po*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5Njk3LjEwLjAuMA..";
        } else if (code == 4) {
          usrimg =
              "https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(5).jpg?alt=media&token=1ac20be7-7724-4dad-9c15-5644aca87254&_gl=1*ba812w*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NzA2LjEuMC4w";
        } else if (code == 5) {
          usrimg =
              "https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(6).jpg?alt=media&token=830327e4-798e-422b-a105-e0c3b8bdd2cc&_gl=1*1qz7svu*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NzE1LjUyLjAuMA..";
        } else if (code == 6) {
          usrimg =
              "https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(7).jpg?alt=media&token=f0934e9c-4e70-4d34-9e76-9aab160ded4e&_gl=1*m1bja5*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NzM2LjMxLjAuMA..";
        } else if (code == 7) {
          usrimg =
              "https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(8).jpg?alt=media&token=4fad4f20-8e70-436c-b1a3-31360ab194c1&_gl=1*1k8pi2k*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NzQ1LjIyLjAuMA..";
        } else if (code == 8) {
          usrimg =
              "https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(9).jpg?alt=media&token=1f98e9d5-db4d-42e5-96b6-9b74ea72d343&_gl=1*1qiutml*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NzUzLjE0LjAuMA..";
        }

        final prefs = await SharedPreferences.getInstance();
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass)
            .then((onValue) {
          String? user = onValue.user?.uid;
          //  if (onValue.user!.emailVerified) {
          FirebaseFirestore.instance.collection('Users').doc(user).set({
            'Full Name': name,
            'Email': email,
            'Phone': phone,
            'Password': pass,
            'Usr Image': usrimg,
          }).then((value) {
            prefs.setBool('user', true);
            prefs.setString("email", email);
            prefs.setString("phone", phone);
            prefs.setString("pass", pass);
            prefs.setString("name", name);
            prefs.setString("usrimg", usrimg);
            prefs.setString("uid", user!);
            setState(() {
              isloading = false;
            });
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()),
                (Route<dynamic> route) => false);
            SnackUtil.showSnackBar(
              context: context,
              text: "Signup Successfully",
              textColor: AppColors.creamColor,
              backgroundColor: Colors.green,
            );
          });
          // } else {
          //   onValue.user!.sendEmailVerification();
          //   SnackUtil.showSnackBar(
          //     context: context,
          //     text: "Verification email sent. Please check your inbox or spam.",
          //     textColor: Colors.white,
          //     backgroundColor: Colors.green,
          //     duration: 15,
          //   );
          // }
        });
      } catch (er, st) {
        setState(() {
          isloading = false;
        });
        SnackUtil.showSnackBar(
          context: context,
          text: "Something Went wrong: $er",
          textColor: AppColors.creamColor,
          backgroundColor: Colors.red.shade200,
        );
      }
    }
  }
}
