import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:registr_login/HomePage.dart';
//import 'package:registr_login/MyDonations.dart';
import 'package:registr_login/Routes/router_config.dart';
//import 'NgoPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: NgoPage(),
    // );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: MyDonations(),
    // );
    // return MaterialApp(
    //   home: Scaffold(
    //     body: StreamBuilder(builder: ),
    //   ),
    // );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser:
          NyAppRouter.returnRouter(false).routeInformationParser,
      routerDelegate: NyAppRouter.returnRouter(false).routerDelegate,
    );
  }
}
