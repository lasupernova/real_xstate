import 'package:flutter/material.dart';

import '../dummy_data/propertyTileDummy.dart';

class PropertyOverviewScreen extends StatelessWidget {
  static const routeName = "/properties_overview";

  List<dynamic> _currentTileList =
      propertyTileDummy; // created for latter TODO (add filter menu, to filter properties based on parameters, e.g. totalIncome etc.)

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
      body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
                child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 3,
                  child: Center(child: _currentTileList[index]),
                );
              },
              itemCount: _currentTileList.length,
            )),
          ),
        ],
      ),
    );
  }
}
