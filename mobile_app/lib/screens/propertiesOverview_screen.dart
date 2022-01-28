import 'package:flutter/material.dart';
import 'package:mobile_app/screens/newPropertyForm_screen.dart';
import 'package:provider/provider.dart';

import '../providers/property_list.dart';
import '../widgets/propertyOverviewTile.dart';

class PropertyOverviewScreen extends StatelessWidget {
  static const routeName = "/properties_overview";

  // created for latter TODO (add filter menu, to filter properties based on parameters, e.g. totalIncome etc.)

  @override
  Widget build(BuildContext context) {
    // final _properties = Provider.of<PropertyList>(context).fetchProperties;
    return Scaffold(
      appBar: AppBar(
        // title: Text("Properties"),
        // centerTitle: true,
        title: Row(children: [
          // added IconButtons() previosuly under "actions" to "title", for them to be centered in AppBar
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(NewPropertyForm.routeName);
            },
            icon: Icon(Icons.add_business),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          IconButton(
              onPressed: () => print("Filtering will be implemented"),
              icon: Icon(Icons.filter_alt)),
          IconButton(
              onPressed: () => print("Sharing/Downloading will be implemented"),
              icon: Icon(Icons.download)),
        ]),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(child: Consumer<PropertyList>(
              builder: (context, props, child) {
                List allProps = props.fetchProperties;
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 3,
                      child: Center(
                          child: PropertyOverviewTile(
                        passedProperty: allProps[index],
                      )),
                    );
                  },
                  itemCount: allProps.length,
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}
