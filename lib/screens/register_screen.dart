import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:users/global/global.dart';
import 'package:users/screens/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
          .createUserWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim())
          .then((auth) async {
        currentUser = auth.user;
        if (currentUser != null) {
          Map userMap = {
            "id": currentUser!.uid,
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "address": addressTextEditingController.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
          };

          DatabaseReference userReference =
              FirebaseDatabase.instance.ref().child("users");
          userReference.child(currentUser!.uid).set(userMap);
        }
        await Fluttertoast.showToast(msg: "Successfullly Registered");
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error occured: \n $errorMessage");
      });
    } else {
      Fluttertoast.showToast(msg: "Not all fields are Valid");
    }
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
                  "Register",
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
                                    hintText: "Name",
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
                                      Icons.person,
                                      color: darkTheme
                                          ? Colors.amber[400]
                                          : Colors.grey,
                                    )),
                                autocorrect: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Mumu put your name";
                                  }
                                  if (text.length < 2) {
                                    return "Which kind name be dis?";
                                  }
                                  if (text.length > 49) {
                                    return "Which kind name be dis?";
                                  }
                                },
                                onChanged: (text) {
                                  setState(() {
                                    nameTextEditingController.text = text;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
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
                              IntlPhoneField(
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                disableLengthCheck: true,
                                showCountryFlag: false,
                                dropdownIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: darkTheme
                                      ? Colors.amber[400]
                                      : Colors.grey,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11)
                                ],
                                decoration: InputDecoration(
                                  hintText: "Phone number",
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
                                ),
                                initialCountryCode: '234',
                                onChanged: (text) {
                                  setState(
                                    () {
                                      phoneTextEditingController.text =
                                          text.completeNumber;
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Address",
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
                                      Icons.home,
                                      color: darkTheme
                                          ? Colors.amber[400]
                                          : Colors.grey,
                                    )),
                                autocorrect: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Mumu put your address";
                                  }
                                  if (text.length < 2) {
                                    return "Which kind address be dis?";
                                  }
                                  if (text.length > 100) {
                                    return "Which kind address be dis?";
                                  }
                                },
                                onChanged: (text) {
                                  setState(() {
                                    addressTextEditingController.text = text;
                                  });
                                },
                              ),
                              SizedBox(
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
                              TextFormField(
                                obscureText: !passwordVisible,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
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
                                  if (text !=
                                      passwordTextEditingController.text) {
                                    return "Password does not match use your eyes ";
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
                                    confirmTextEditingController.text = text;
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
                                    "Register",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                      color: darkTheme
                                          ? Colors.amber[400]
                                          : Colors.blue),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Have an account",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Sign in",
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
