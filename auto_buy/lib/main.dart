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


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthService>(
      create:(context) => FirebaseAuthService(),
      child: MaterialApp(
        title: 'AUTO BUY',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: WrapperPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

