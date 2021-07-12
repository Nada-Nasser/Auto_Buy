import 'package:auto_buy/screens/no_connection_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final connected = false;

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool hasNetworkConnection;
//  bool fallbackViewOn;

  //ConnectionStatusSingleton connectionStatus;
  @override
  void initState() {
    /*hasNetworkConnection = false;
    fallbackViewOn = false;
    connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    connectionStatus.connectionChange.listen(_updateConnectivity);
    */
    //if(!connectionStatus.hasConnection) _updateConnectivity(false);

    super.initState();
  }

/*
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  void _updateConnectivity(dynamic hasConnection) {
    print("CHECK");
    if (!hasNetworkConnection) {
      if (!fallbackViewOn) {
        navigatorKey.currentState.pushNamed(NoInternetConnectionScreen.route);
        print("no connection");
        setState(() {
          fallbackViewOn = true;
          hasNetworkConnection = hasConnection;
        });
      }
    } else {
      if (fallbackViewOn) {
        print("connection");
        navigatorKey.currentState.pop(context);
        setState(() {
          fallbackViewOn = false;
          hasNetworkConnection = hasConnection;
        });
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthService>(
      create: (context) => FirebaseAuthService(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => WrapperPage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/no_connection': (context) => NoInternetConnectionScreen(),
        },
        //      navigatorKey: navigatorKey,
        title: 'AUTO BUY',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        // home: WrapperPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

