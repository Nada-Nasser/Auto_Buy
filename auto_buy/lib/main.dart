import 'package:auto_buy/screens/no_connection_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dcdg/dcdg.dart';
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final connected = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthService>(
      create: (context) => FirebaseAuthService(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => WrapperPage(),
          '/no_connection': (context) => NoInternetConnectionScreen(),
        },
        navigatorKey: navigatorKey,
        title: 'AUTO BUY',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

