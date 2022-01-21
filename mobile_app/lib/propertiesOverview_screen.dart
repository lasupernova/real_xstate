import 'package:flutter/material.dart';

class PropertyOverviewScreen extends StatelessWidget {
  static const routeName = "/properties_overview";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Properties"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () => print("Adding Property"),
            icon: Icon(Icons.add_business),
            color: Theme.of(context).colorScheme.onPrimary,
          )
        ],
      ),
    );
  }
}
