import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'dart:async';

// klasa odpowiedzialna za zmiane ustawien wyswietlania odleglosci, predkosci masy ciala i wzrostu biegacza
class SettingsRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<SettingsRoute> {
  bool metricDistanse = true; //czy odleglosc w jednostkach metrycznych
  var distanceUnits = " km";
  bool metricSpeed = true; //czy predkosc w jednostkach metrycznych
  var speedUnits = " km/h";
  double heightSliderValue = 175; //domyslna wartosc wzrostu
  double weightSliderValue = 70; //domyslna wartosc masy

  // metoda zmieniajaca jednostki odleglosci
  void changeDistanceSettings(bool metricDistanse) {
    if (metricDistanse == true) {
      distanceUnits = "km";
    } else {
      distanceUnits = "mi";
    }

    setState(() {
      distanceUnits = distanceUnits;
    });
  }

  // metoda zmieniajaca jednostki predkosci
  void changeSpeedSettings(bool metricSpeed) {
    if (metricSpeed == true) {
      speedUnits = "km/h";
    } else {
      speedUnits = "mi/h";
    }

    setState(() {
      speedUnits = speedUnits;
    });
  }

  // metoda wczytujaca zapisane jednostki
  Future<void> getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    metricDistanse = prefs.getBool('distance_settings') ?? false;
    metricSpeed = prefs.getBool('speed_settings') ?? false;
    heightSliderValue = prefs.getDouble('height') ?? 175;
    weightSliderValue = prefs.getDouble('weight') ?? 70;
  }

  // metoda zapisujaca zmienione jednostki
  Future<void> saveSettings(bool metricDistanse, bool metricSpeed,
      double height, double weight) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool('speed_settings', metricSpeed);
    prefs.setBool('distance_settings', metricDistanse);
    prefs.setDouble('height', height);
    prefs.setDouble('weight', weight);
  }

  @override
  Widget build(BuildContext context) {
    getSharedPreferences();

    return Scaffold(
        appBar: AppBar(
          title: Text('Ustawienia'),
        ),
        body: Center(
          child: ListView(
            padding: EdgeInsets.only(left: 10, right: 10),
            children: [
              SwitchListTile(
                title: Text("$distanceUnits"),
                value: metricDistanse,
                onChanged: (bool value) {
                  setState(() {
                    metricDistanse = value;
                    changeDistanceSettings(metricDistanse);
                    saveSettings(metricDistanse, metricSpeed, heightSliderValue,
                        weightSliderValue);
                  });
                },
                secondary: const Icon(Icons.add_road),
              ),
              SwitchListTile(
                title: Text("$speedUnits"),
                value: metricSpeed,
                onChanged: (bool value) {
                  setState(() {
                    metricSpeed = value;
                    changeSpeedSettings(metricSpeed);
                    saveSettings(metricDistanse, metricSpeed, heightSliderValue,
                        weightSliderValue);
                  });
                },
                secondary: const Icon(Icons.speed),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 2, child: Text("wzrost")),
                  Expanded(
                      flex: 8,
                      child: Slider(
                        // wzrost
                        value: heightSliderValue,
                        min: 110.0,
                        max: 230.0,
                        divisions: 120,
                        label: heightSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            heightSliderValue = value;
                            saveSettings(metricDistanse, metricSpeed,
                                heightSliderValue, weightSliderValue);
                          });
                        },
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 2, child: Text("waga")),
                  Expanded(
                      flex: 8,
                      child: Slider(
                        // masa w kg
                        value: weightSliderValue,
                        min: 30.0,
                        max: 180.0,
                        divisions: 150,
                        label: weightSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            weightSliderValue = value;
                            saveSettings(metricDistanse, metricSpeed,
                                heightSliderValue, weightSliderValue);
                          });
                        },
                      ))
                ],
              ),
            ],
          ),
        ));
  }
}
