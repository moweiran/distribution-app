import 'package:distribution_app/shell/run_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

/// The route configuration.
final router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage(title: 'Distribution App');
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'run',
          path: 'run/:id',
          builder: (BuildContext context, GoRouterState state) {
            return RunShellPage(id: int.parse(state.params['id']!));
          },
        ),
        // GoRoute(
        //   path: 'barcode',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const BarcodeDemoPage();
        //   },
        // ),
        // GoRoute(
        //   path: 'integrate',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const IntegrateDemoPage();
        //   },
        // ),
        // GoRoute(
        //   path: 'camera',
        //   builder: (context, state) {
        //     return const CameraDemoPage();
        //   },
        // )
      ],
    ),
    // GoRoute(
    //   path: 'run',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return RunShellPage(id: 1);
    //   },
    // ),
  ],
);
