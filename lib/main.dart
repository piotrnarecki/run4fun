import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run4fun/login_route.dart';
import 'settings_route.dart';
import 'training_route.dart';

// Funkcja runApp() pobiera dany widżet i czyni go głównym drzewem widżetów.
// W tym przykładzie drzewo widżetów składa się z trzech widżetów,
// widżetu ChangeNotifierProvider, który udostępnia API powiadomień o zmianach,
// jego elementu podrzędnego, widżetu MaterialApp związanego z układem widżetów
// oraz LoginRoute należącego do tablicy routingu.
void main(){
  runApp(
      ChangeNotifierProvider(
          create: (context) => ApplicationState(),
        child: MaterialApp(
          title: 'Navigation Basics',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          home: LoginRoute(),
        )
      ),
  );
}