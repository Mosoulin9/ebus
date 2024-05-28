import 'package:ebus/screens/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  int _secondsRemaining = 3;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_secondsRemaining < 1) {
            timer.cancel();
            // Navigate to the main screen after the splash screen timer finishes
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => Login(),
              ),
            );
          } else {
            _secondsRemaining--;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "images/in.png",
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              Spacer(),
              Align(
                child: Image.asset(
                  "images/logo.png",
                  height: 20,
                ),
              ),
              Spacer(),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 120.0, right: 120.0, bottom: 50),
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0XFF7b54a2),
                      backgroundColor: Colors.blueGrey.withOpacity(0.5),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
