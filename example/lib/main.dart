import 'package:example/pages/page_sample.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'example_route.dart';
import 'example_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'extended_tabs demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageSample(),
      // initialRoute: Routes.fluttercandiesMainpage,
      // onGenerateRoute: (RouteSettings settings) {
      //   return onGenerateRoute(
      //     settings: settings,
      //     getRouteSettings: getRouteSettings,
      //     routeSettingsWrapper: (FFRouteSettings ffRouteSettings) {
      //       if (ffRouteSettings.name == Routes.fluttercandiesMainpage ||
      //           ffRouteSettings.name == Routes.fluttercandiesDemogrouppage) {
      //         return ffRouteSettings;
      //       }
      //       return ffRouteSettings.copyWith(
      //           builder: () => CommonWidget(
      //                 child: ffRouteSettings.builder(),
      //                 title: ffRouteSettings.routeName,
      //               ));
      //     },
      //   );
      // },
    );
  }
}

class CommonWidget extends StatelessWidget {
  const CommonWidget({
    this.child,
    this.title,
  });
  final Widget? child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title!,
        ),
      ),
      body: child,
    );
  }
}
