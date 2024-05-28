import 'dart:ui';
import 'package:ebus/screens/login.dart';
import 'package:ebus/screens/signup.dart';
import 'package:ebus/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompSignup extends StatefulWidget {
  const CompSignup({super.key});

  @override
  State<CompSignup> createState() => _CompSignupState();
}

class _CompSignupState extends State<CompSignup> {
  GlobalKey<FormState> keys = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "images/ebb.png",
            fit: BoxFit.fill,
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 80, horizontal: 41),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 5,
                        sigmaY: 5), // Adjust the sigma values as needed
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black, // Color of the outer glow
                            spreadRadius: 20,
                            // Adjust spread radius as needed
                            blurRadius: 5, // Adjust blur radius as needed
                            blurStyle:
                                BlurStyle.outer, // Adjust blur radius as needed
                          ),
                        ],
                        borderRadius: BorderRadius.circular(
                            16), // Adjust radius to compensate for the stroke
                        border: Border.all(
                            color: Colors.white, width: 0.5), // Add blue stroke
                      ),
                      child: Form(
                        key: keys,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // Child widgets of the container
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 70.0),
                                child: Image.asset(
                                  "images/logo.png",
                                  height: 20,
                                ),
                              ),
                              Text(
                                "Company Signup",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Faint shadow color
                                          spreadRadius: 2, // Spread radius
                                          blurRadius: 5, // Blur radius
                                          offset: Offset(0,
                                              2), // Offset from the container
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.white, width: 0.5),
                                      color: Colors.white.withOpacity(0.3)),
                                  child: TextFormField(
                                    controller: name,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Company ID";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        focusColor: Colors.white,
                                        hintText: "Company ID",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        prefixIcon: Icon(
                                          CupertinoIcons.number_square_fill,
                                          color: Colors.grey[400],
                                        ),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Faint shadow color
                                          spreadRadius: 2, // Spread radius
                                          blurRadius: 5, // Blur radius
                                          offset: Offset(0,
                                              2), // Offset from the container
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.white, width: 0.5),
                                      color: Colors.white.withOpacity(0.3)),
                                  child: TextFormField(
                                    controller: email,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Your email";
                                      } else if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                        return "Enter a valid email address";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        prefixIcon: Icon(
                                          CupertinoIcons.envelope_fill,
                                          color: Colors.grey[400],
                                        ),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 0.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Faint shadow color
                                          spreadRadius: 2, // Spread radius
                                          blurRadius: 5, // Blur radius
                                          offset: Offset(0,
                                              2), // Offset from the container
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white.withOpacity(0.3)),
                                  child: TextFormField(
                                    obscureText: passToggle,
                                    controller: password,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Password";
                                      } else if (value.length < 4) {
                                        return "Password should be greater than 4 characters";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            if (passToggle == true) {
                                              passToggle = false;
                                              setState(() {});
                                            } else {
                                              passToggle = true;
                                              setState(() {});
                                            }
                                          },
                                          splashColor: Colors.white,
                                          child: Icon(
                                            passToggle
                                                ? CupertinoIcons.eye_slash_fill
                                                : CupertinoIcons.eye,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          CupertinoIcons.lock_shield_fill,
                                          color: Colors.grey[400],
                                        ),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  if (keys.currentState!.validate()) {
                                    compsignup(context, name.text, email.text,
                                        password.text);
                                  }
                                },
                                splashColor: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.lightGreenAccent,
                                          width: 0.5),
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0XFF3d4897),
                                          Color(0XFFbe5bad)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Faint shadow color
                                          spreadRadius: 2, // Spread radius
                                          blurRadius: 5, // Blur radius
                                          offset: Offset(0,
                                              2), // Offset from the container
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 88),
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Signup()));
                                        },
                                        child: Text(
                                          "Customer Signup?",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        )),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()));
                                        },
                                        child: Text(
                                          "Login?",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        )),
                                  ),
                                )
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
