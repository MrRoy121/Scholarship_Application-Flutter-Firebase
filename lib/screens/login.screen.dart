import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/screens/signup.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import 'home_screen.dart';

class SnackUtil {
  static void showSnackBar({
    required BuildContext context,
    required String text,
    required Color textColor,
    required Color backgroundColor,
    int duration = 3,
  }) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: duration),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class LoginScreen extends StatefulWidget {
  final Color backgroundColor;
  final Color primaryColor;
  final AssetImage backgroundImage;

  LoginScreen({
    Key? key,
    this.primaryColor = Colors.green,
    this.backgroundColor = Colors.white,
    this.backgroundImage = const AssetImage("assets/full-bloom.png"),
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isloading = false;
  final _conuserEmail = TextEditingController();

  final _conuserPass = TextEditingController();

  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getBool('user') ?? false;
    if (user) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> login({required BuildContext context}) async {
    setState(() {
      isloading = true;
    });
    String email = _conuserEmail.text.trim();
    String pass = _conuserPass.text.trim();

    final prefs = await SharedPreferences.getInstance();

    if (email.isEmpty) {
      setState(() {
        isloading = false;
      });
      SnackUtil.showSnackBar(
        context: context,
        text: "Email is required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
      return;
    } else if (pass.length < 6) {
      setState(() {
        isloading = false;
      });
      SnackUtil.showSnackBar(
        context: context,
        text: "Password must be at least 6 characters.",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      final user = userCredential.user;

      if (user != null) {
        // if (!user.emailVerified) {
        //   await user.sendEmailVerification();
        //   SnackUtil.showSnackBar(
        //     context: context,
        //     text: "Verification email sent. Please check your inbox or spam.",
        //     textColor: Colors.white,
        //     backgroundColor: Colors.green,
        //     duration: 15,
        //   );
        //   return;
        // }

        final doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            isloading = false;
          });
          await prefs.setBool('user', true);
          await prefs.setString("email", doc.get("Email") ?? '');
          await prefs.setString("phone", doc.get("Phone") ?? '');
          await prefs.setString("pass", doc.get("Password") ?? '');
          await prefs.setString("name", doc.get("Full Name") ?? '');
          await prefs.setString("usrimg", doc.get('Usr Image') ?? '');
          await prefs.setString("uid", doc.id);

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false,
          );

          SnackUtil.showSnackBar(
            context: context,
            text: "Login successful!",
            textColor: AppColors.creamColor,
            backgroundColor: Colors.green,
          );
        } else {
          setState(() {
            isloading = false;
          });
          SnackUtil.showSnackBar(
            context: context,
            text: "User data not found. Please try again.",
            textColor: AppColors.creamColor,
            backgroundColor: Colors.red,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isloading = false;
      });
      print(e);
      String message;
      switch (e.code) {
        case 'invalid-credential':
          message =
              "Your email password seem to be incorrect or expired. Please try logging in again.";
          break;
        case 'invalid-email':
          message = "Invalid email format.";
          break;
        case 'user-disabled':
          message = "This account has been disabled.";
          break;
        case 'user-not-found':
          message = "No account found with this email.";
          break;
        case 'wrong-password':
          message = "Incorrect password.";
          break;
        default:
          message = "An unexpected error occurred. Please try again.";
      }

      SnackUtil.showSnackBar(
        context: context,
        text: message,
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } catch (error) {
      setState(() {
        isloading = false;
      });
      SnackUtil.showSnackBar(
        context: context,
        text: "Something went wrong. Please try again later.",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
      print("Error during login: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    padding: EdgeInsets.only(top: 100.0, bottom: 100.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Scholarships News',
                          style: TextStyle(
                              fontSize: 30.0, color: Color(0xffFCAF38)),
                        ),
                        Text(
                          "Login Screen",
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
                      margin: const EdgeInsets.only(left: 00.0, right: 10.0),
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
                      margin: const EdgeInsets.only(left: 00.0, right: 10.0),
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
                  :   Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              widget.primaryColor, // Replaces `color`
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // Replaces `shape`
                          ),
                          splashFactory:
                              InkSplash.splashFactory, // Default splash effect
                        ),
                        child: new Row(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "LOGIN",
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
                                      backgroundColor:
                                          Colors.white, // Replaces `color`
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            28.0), // Replaces `shape`
                                      ),
                                      shadowColor: Colors.white),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: this.widget.primaryColor,
                                  ),
                                  onPressed: () {
                                    login(context: context);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          login(context: context);
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
                            "DON'T HAVE AN ACCOUNT?",
                            style: TextStyle(color: this.widget.primaryColor),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SignUpScreen()));
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
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
