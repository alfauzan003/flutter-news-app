import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'auth.dart';
import 'login.dart';
import '../widgets/widget_tree.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String errorMessage = '';
  bool isLogin = true;
  String successMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordRepeat =
      TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  _signOut() async {
    await _firebaseAuth.signOut();
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
      errorMessage,
      style: TextStyle(color: Colors.red),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        createUserWithEmailAndPassword();
        errorMessage = '';
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff4c505b),
      ),
      child: Text(
        'Sign Up',
        style: TextStyle(
          color: Colors.white,
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
                            height: 30,
                          ),
                          _submitButton(),
                          SizedBox(
                            height: 40,
                          ),
                          TextButton(
                            child: Text("Already have account? tap here"),
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () {
                              _signOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()));
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
