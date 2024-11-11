import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pfe/Models/User.dart';
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:mobile_pfe/Views/HomePage.dart';
import 'package:mobile_pfe/Services/ServiceLogin.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;

  double getTextFieldWidth(BuildContext context) {
    // change the width for web
    return kIsWeb ? MediaQuery.of(context).size.width * 0.4 : double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.color1,
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Image.asset(
                'assets/images/icon.png',
                height: 200,
                width: 200,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Sign Up',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: getTextFieldWidth(context),
                      child: TextField(
                        controller: emailController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          suffixIcon: emailController.text.isEmpty
                              ? Text('')
                              : GestureDetector(
                                  onTap: () {
                                    emailController.clear();
                                  },
                                  child: Icon(Icons.close),
                                ),
                          hintText: 'example@mail.com',
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: getTextFieldWidth(context),
                      child: TextField(
                        obscureText: isVisible,
                        controller: passwordController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              isVisible = !isVisible;
                              setState(() {});
                            },
                            child: Icon(isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          hintText: 'type your password',
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: SizedBox(
                        width: 100,
                        child: Button(
                          borderRadius: 10,
                          margin: EdgeInsets.all(8.0),
                          bgColor: Constants.color1,
                          onPressed: () async {
                            try {
                              await ServiceLogin.login(emailController.text,
                                  passwordController.text);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            } catch (e) {
                              MotionToast.error(
                                width: 300,
                                height: 50,
                                title: Text(
                                    "Login failed. Please check your credentials."),
                                description: Text(""),
                              ).show(context);
                            }
                          },
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: kWhite,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
