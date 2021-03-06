import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/providers/property_list.dart';
import 'package:mobile_app/screens/mortgageCalculated_Screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:mobile_app/widgets/cashflowResultTile.dart';

import 'screens/propertiesOverview_screen.dart';
import 'screens/cashflowResultDetails._screen.dart';
import './screens/cashflowForm_screen.dart';
import './screens/newPropertyForm_screen.dart';
import './screens/mortgageCalculated_Screen.dart';
import './providers/cashflow_list.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';

// TO DO: create popup form screen for calculating cashflow

Future<void> main() async {
  // loadenvironment varibles specified in .env
  await dotenv
      .load(); // loads file named '.env' by default - different filename can be specified: .load(filanme: '<someOtherFile>')
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => PropertyList()),
        ChangeNotifierProvider(create: (ctx) => CashflowList()),
        ChangeNotifierProvider(create: (ctx) => Auth())
      ],
      child: MaterialApp(
        // CupertinoApp
        title: 'Real X State',
        theme: ThemeData(
            colorScheme: ColorScheme.light().copyWith(
              primary: Colors.purple,
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
        home: AuthScreen(), // LandingPage(),
        routes: {
          PropertyOverviewScreen.routeName: (ctx) => PropertyOverviewScreen(),
          CfResultDetailsScreen.routeName: (ctx) => CfResultDetailsScreen(),
          // ignore: prefer_const_constructors
          CashflowForm.routeName: (ctx) => CashflowForm(),
          NewPropertyForm.routeName: (ctx) => NewPropertyForm(),
          MortgageResult.routeName: (ctx) => MortgageResult(),
        },
      ),
    );
    ;
  }
}

class LandingPage extends StatelessWidget {
  static const routeName = "/";
  bool _firstLoad = true;

  void _popupCashflowForm(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(CashflowForm.routeName);

    // //BUildocntext (ctx)argument is automatically filled into this function by flutter; NOTE: bCtx is also a context, but a different one (again passed automatically)
    // context: ctx,
    // builder: // builder is a function that will return+build the widget that will be contained in the showModalBottomSHeet-class
    //     (bCtx) {
    //   return Container(
    //     padding: const EdgeInsets.all(5),
    //     height: MediaQuery.of(ctx).size.height * 0.4,
    //     width: MediaQuery.of(ctx).size.width,
    //     child: ElevatedButton(
    //       onPressed: () async {
    //         var resp = await http.get(Uri.parse("http://127.0.0.1:5000/"));
    //         var decodedData = jsonDecode(resp);
    //       },
    //       child: Row(
    //         children: [Icon(Icons.calculate), Text("Get Mortbgage .py")],
    //       ),
    //     ),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (_firstLoad) {
      Provider.of<CashflowList>(context, listen: false)
          .getCFs(); // only update on first load -- otherwise listen to added entries from within app
      _firstLoad = !_firstLoad;
    }
    ;

    return Scaffold(
      appBar: AppBar(
        title: Text(" --- Placeholder Title ---"), //
        actions: <Widget>[
          IconButton(
              onPressed: () => print("Filtering will be implemented"),
              icon: Icon(Icons.filter_alt)),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(child: Consumer<CashflowList>(
              builder: (context, props, child) {
                List allCFs = props.fetchCFs;
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 3,
                      child: Center(
                        child: CashflowResultTile(
                          name: allCFs[index].id,
                          ROI: DateTime.now(),
                          cashflow: 0.98,
                          worth: false,
                        ),
                      ),
                    );
                  },
                  itemCount: allCFs.length,
                );
              },
            )),
          ),
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          // backgroundColor: Theme.of(context).colorScheme.secondary,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Navigation",
                      style: TextStyle(fontSize: 20, color: Color(0xFFd8d7e0)),
                    )),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/no_entries.jpg'))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              ListTile(
                leading: Icon(Icons.business_center_outlined),
                title: Text("Portfolio"),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(PropertyOverviewScreen.routeName);
                },
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.02,
              // ),
              ListTile(
                  leading: Icon(Icons.money),
                  title: Text("Calculated Cashflow"),
                  onTap: () {
                    Navigator.of(context).pushNamed("/");
                  }),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.02,
              // ),
              ListTile(
                  leading: Icon(Icons.ramen_dining),
                  title: Text("3rd option"),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _popupCashflowForm(context),
        child: Icon(Icons.calculate),
      ),
    );
  }
}
