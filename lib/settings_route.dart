import 'package:flutter/material.dart';

import 'main.dart';

import 'settings_route.dart';
import 'training_route.dart';

class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location Example',
        theme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Settings Route'),
          ),
          body: Center(
            child: ElevatedButton(
              child: Text('Main route'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (MainRoute())),
                );
              },
            ),
          ),
        ));
  }
}
