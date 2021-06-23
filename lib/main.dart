import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run4fun/login_route.dart';
import 'settings_route.dart';
import 'training_route.dart';

void main(){
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // tutaj metoda sprawdzająca czy użytkownik jest zalogowany

  // metoda wyswietlanjaca imię i statystki użytkownika

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