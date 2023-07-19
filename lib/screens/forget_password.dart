import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users/global/global.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  final emailTextEditingController = TextEditingController();
  //declare a Globalkey

  final _formKey = GlobalKey<FormState>();

  void submit() {
    firebaseAuth
        .sendPasswordResetEmail(email: emailTextEditingController.text.trim())
        .then((value) => Fluttertoast.showToast(
            msg: "We have sent an email to recover your password"))
        .onError((error, stackTrace) => Fluttertoast.showToast(
            msg: "Error Occured \n ${error.toString()}"));
  }

  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool passwordVisible = false;
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
                  "Reset Password",
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
                                    "Reset Password",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
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
