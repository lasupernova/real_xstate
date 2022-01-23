import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/cashflowResultTile.dart';

import 'screens/propertiesOverview_screen.dart';
import 'screens/cashflowResultDetails._screen.dart';
import './dummy_data/cashflowTileDummy.dart';

// TO DO: create popup form screen for calculating cashflow

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // CupertinoApp
      title: 'Real X State',
      theme: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
            primary: Colors.pink,
            secondary: Colors.amber,
          ),
          textTheme: const TextTheme(
            headline6: TextStyle(fontSize: 17.0),
            headline5: TextStyle(fontSize: 20),
            subtitle1: TextStyle(fontSize: 15),
            subtitle2: TextStyle(fontSize: 13),
            bodyText1: TextStyle(fontSize: 11),
            bodyText2: TextStyle(fontSize: 9),
          )),
      home: LandingPage(),
      routes: {
        PropertyOverviewScreen.routeName: (ctx) => PropertyOverviewScreen(),
        CfResultDetailsScreen.routeName: (ctx) => CfResultDetailsScreen(),
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  static const routeName = "/";

  void _popupCashflowForm(BuildContext ctx) {
    //BUildocntext (ctx)argument is automatically filled into this function by flutter; NOTE: bCtx is also a context, but a different one (again passed automatically)
    showModalBottomSheet(
        context: ctx,
        builder: // builder is a function that will return+build the widget that will be contained in the showModalBottomSHeet-class
            (bCtx) {
          return PropertyOverviewScreen();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" --- Placeholder Title ---"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
                child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 3,
                  child: Center(child: cashflowTileDummy[index]),
                );
              },
              itemCount: cashflowTileDummy.length,
            )),
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(PropertyOverviewScreen.routeName),
                  child: Text("Switch to Portfolio")),
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _popupCashflowForm(context),
        child: Icon(Icons.calculate),
      ),
    );
  }
}
