import 'package:flutter/material.dart';
import 'settings_route.dart';
import 'training_route.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: MainRoute(),
  ));
}

class MainRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Run 4 Fun'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            child: Text('Training'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (TrainingRoute())),
              );
            },
          ),
          ElevatedButton(
            child: Text('Settings'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (SettingsRoute())),
              );
            },
          ),
        ],
      )),
    );
  }
}
