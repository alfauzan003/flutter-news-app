import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'signup.dart';
import '../widgets/widget_tree.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _entryFieldEmail(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }

  Widget _entryFieldPassword(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Email or Password you entered is incorrect',
      style: TextStyle(color: Colors.red),
    );
  }

  Widget _submitButton() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Color(0xff4c505b),
      child: IconButton(
        color: Colors.white,
        onPressed: () {
          signInWithEmailAndPassword();
          return WidgetTree();
        },
        icon: Icon(
          Icons.arrow_forward,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Welcome',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          _entryFieldEmail('email', _controllerEmail),
                          SizedBox(
                            height: 30,
                          ),
                          _entryFieldPassword('password', _controllerPassword),
                          SizedBox(
                            height: 40,
                          ),
                          _errorMessage(),
                          SizedBox(
                            height: 40,
                          ),
                          _submitButton(),
                          SizedBox(
                            height: 40,
                          ),
                          TextButton(
                            child: Text("Don't have account? tap here"),
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
