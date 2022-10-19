import 'package:fix_realxstate/providers/property_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './screens/auth_screen.dart';
import './screens/landing.dart';
import './screens/propertiesOverview_screen.dart';
import './screens/cashflowResultDetails._screen.dart';
import './screens/cashflowForm_screen.dart';
import './screens/newPropertyForm_screen.dart';
import './screens/mortgageCalculated_Screen.dart';
import './screens/splash_screen.dart';

import './providers/auth.dart';
import './providers/cashflow_list.dart';

Future<void> main() async {
  // loadenvironment varibles specified in .env
  await dotenv.load(
      fileName:
          '.env'); // loads file named '.env' by default - different filename can be specified: .load(filanme: '<someOtherFile>')
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider(create: (ctx) => PropertyList()),
          ChangeNotifierProvider(
              create: (ctx) =>
                  Auth()), // Note: Auth() needs to be provided first, in order to be able to use it in ChangeNotifierproxyProvider
          ChangeNotifierProxyProvider<Auth, CashflowList>(
            create: (ctx) => CashflowList(null, null, []),
            update: (ctx, auth, previousCashflow) => CashflowList(
                auth.token,
                auth.userID,
                previousCashflow == null ? [] : previousCashflow.entries),
          ),
          ChangeNotifierProxyProvider<Auth, PropertyList>(
            create: (ctx) => PropertyList(null, null, []),
            update: (ctx, auth, previousProperties) => PropertyList(
                auth.token,
                auth.userID,
                previousProperties == null ? [] : previousProperties.entries),
          ), //will be rebuild when auth changes, as auth is now a dependency of the proxy-provider
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            // use Consumer to only re-build this part of app upon changes in Auth
            // CupertinoApp
            title: 'Real X State',
            theme: ThemeData(
                colorScheme: ColorScheme.dark().copyWith(
                  primary: Color.fromARGB(255, 49, 49, 49),
                  secondary: Colors.blueGrey,
                  onPrimary: Colors.white,
                  onSecondary: Colors.black,
                  onTertiary: Color.fromARGB(255, 156, 156, 156),
                ),
                textTheme: const TextTheme(
                  headline6: TextStyle(fontSize: 17),
                  headline5: TextStyle(fontSize: 20),
                  subtitle1: TextStyle(fontSize: 15),
                  subtitle2: TextStyle(fontSize: 13),
                  bodyText1: TextStyle(fontSize: 11),
                  bodyText2: TextStyle(fontSize: 9),
                )),
            home: authData.isAuth
                ? LandingPage() // if already authenticated -> got o landing page
                : FutureBuilder(
                    // otherwise try autologin
                    builder: (ctx, authLoginTryResult) => authLoginTryResult
                                .connectionState ==
                            ConnectionState.waiting
                        ? SplashScreen() // while waiting for result of auto login show splash screen
                        : AuthScreen(),
                    future: authData.tryAutoLogin()),
            routes: {
              PropertyOverviewScreen.routeName: (ctx) =>
                  PropertyOverviewScreen(),
              CfResultDetailsScreen.routeName: (ctx) => CfResultDetailsScreen(),
              // ignore: prefer_const_constructors
              CashflowForm.routeName: (ctx) => CashflowForm(),
              NewPropertyForm.routeName: (ctx) => NewPropertyForm(),
              MortgageResult.routeName: (ctx) => MortgageResult(),
              LandingPage.routeName: (ctx) => LandingPage(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          ),
        ));
    ;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
