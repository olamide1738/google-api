import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:users/global/global.dart';
import 'package:users/screens/forget_password.dart';
import 'package:users/screens/main_screen.dart';
import 'package:users/splashScreen/splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();

  bool passwordVisible = false;

  //declare a Globalkey

  final _formKey = GlobalKey<FormState>();
  void submit() async {
    //validate all the form fields
    if (_formKey.currentState!.validate()) {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim())
          .then((auth) async {
        currentUser = auth.user;

        await Fluttertoast.showToast(msg: "Successfully Logged In");
        Navigator.of(context).push(_createRoute1());
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error occured: \n $errorMessage");
      });
    } else {
      Fluttertoast.showToast(msg: "Not all fields are Valid");
    }
  }

  Route _createRoute1() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SplashScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset(darkTheme
                    ? "assets/images/city_dark.png"
                    : "assets/images/city.png"),
                const SizedBox(height: 20),
                Text(
                  "Login",
                  style: TextStyle(
                    color: darkTheme ? Colors.amber[400] : Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                  child: Column(
                    children: [
                      Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: darkTheme
                                        ? Colors.black45
                                        : Colors.grey[200],
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: darkTheme
                                          ? Colors.amber[400]
                                          : Colors.grey,
                                    )),
                                autocorrect: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Mumu put your email";
                                  }
                                  if (EmailValidator.validate(text) == true) {
                                    return null;
                                  }
                                  if (text.length < 2) {
                                    return "Which kind email be dis?";
                                  }
                                  if (text.length > 49) {
                                    return "Which kind email be dis?";
                                  }
                                },
                                onChanged: (text) {
                                  setState(() {
                                    emailTextEditingController.text = text;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                obscureText: !passwordVisible,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme
                                      ? Colors.black45
                                      : Colors.grey[200],
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: darkTheme
                                        ? Colors.amber[400]
                                        : Colors.grey,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    color: darkTheme
                                        ? Colors.amber[400]
                                        : Colors.grey,
                                  ),
                                ),
                                autocorrect: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Mumu put your password";
                                  }

                                  if (text.length < 2) {
                                    return "Your pa";
                                  }
                                  if (text.length > 49) {
                                    return "Which kind password be dis?";
                                  }
                                },
                                onChanged: (text) {
                                  setState(() {
                                    passwordTextEditingController.text = text;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: darkTheme
                                          ? Colors.amber[400]
                                          : Colors.blue,
                                      onPrimary: darkTheme
                                          ? Colors.black
                                          : Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      minimumSize: Size(double.infinity, 50)),
                                  onPressed: () {
                                    submit();
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) =>
                                              ForgetPasswordScreen()));
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                            color: darkTheme
                                                ? Colors.amber[400]
                                                : Colors.blue),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Reset Password",
                                        style: TextStyle(
                                            color: darkTheme
                                                ? Colors.blue
                                                : Colors.amber[400]),
                                      ),
                                    ]),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: darkTheme
                                          ? Colors.amber[400]
                                          : Colors.blue),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
