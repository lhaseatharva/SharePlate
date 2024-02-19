import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:registr_login/EntryPage.dart';
import 'package:registr_login/MyDonations.dart';
import 'package:registr_login/NeedyPage.dart';
import 'package:registr_login/NgoPage.dart';
//import 'package:registr_login/Routes/router_constant.dart';
import 'package:registr_login/login.dart';
import 'package:registr_login/register.dart';

class NyAppRouter {
  static GoRouter returnRouter(bool isAuth) {
    GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(child: EntryPage());
          },
        ),
        // Route for login screen
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => const MaterialPage(child: MyLogin()),
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) => const MaterialPage(child: MyRegister()),
        ),
        GoRoute(
          path: '/requestfood',
          name: "request",
          pageBuilder: (context, state) => MaterialPage(
            child: NeedyRequestPage(),
          ),
        ),
        GoRoute(
          path: '/mydonations',
          name: "mydonations",
          pageBuilder: (context, state) => const MaterialPage(
            child: MyDonations(),
          ),
        ),
        GoRoute(
          path: '/ngopage',
          name: "ngopage",
          pageBuilder: (context, state) => const MaterialPage(
            child: NgoPage(),
          ),
        ),
      ],
    );

    return router;
  }
}
