import 'package:ebus/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ebus/splash.dart'; // Replace 'your_app' with the actual package name

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ebus + Courier Connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.transparent,
        useMaterial3: true,
      ),
      home: Splash(),
    );
  }
}
