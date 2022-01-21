import 'package:flutter/material.dart';

import './propertiesOverview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real X State',
      theme: ThemeData(
        colorScheme: ColorScheme.light().copyWith(
          primary: Colors.pink,
          secondary: Colors.amber,
        ),
      ),
      home: LandingPage(),
      routes: {
        PropertyOverviewScreen.routeName: (ctx) => PropertyOverviewScreen(),
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  static const routeName = "/";

  List<String> entries = [
    'Test1',
    'Test2',
    'Test3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" --- Placeholder Title ---"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                child: Center(child: Text('Entry ${entries[index]}')),
              );
            },
            itemCount: entries.length,
          )),
          ElevatedButton(onPressed: () {}, child: Text("Take me to properties"))
        ],
      ),
    );
  }
}
