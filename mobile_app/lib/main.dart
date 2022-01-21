import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light().copyWith(
          primary: Colors.pink,
          secondary: Colors.amber,
        ),
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" --- Placeholder Title ---"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(" --- Main Page ---"),
      ),
    );
  }
}
