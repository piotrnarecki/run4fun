import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:run4fun/main.dart';

import 'history_route.dart';
import 'widgets.dart';
import 'authentication.dart';

import 'package:intl/intl.dart';

import 'training_route.dart';
import 'settings_route.dart';

class LoginRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trening',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
          highlightColor: Colors.deepPurple,
        ),
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM').format(now);
    return Scaffold(
      appBar: AppBar(
        title: Text('Run4Fun'),
      ),
      body: ListView(
          children: <Widget>[

      Image.asset('assets/running-facts-crazy.png'),
      SizedBox(height: 8),
        IconAndDetail(Icons.calendar_today, formattedDate),
        IconAndDetail(Icons.location_city, 'Wrocław'),
        Consumer<ApplicationState>(
          builder: (context, appState, _) => Authentication(
            loginState: appState.loginState,
            email: appState.email,
            startLoginFlow: appState.startLoginFlow,
            verifyEmail: appState.verifyEmail,
            signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
            cancelRegistration: appState.cancelRegistration,
            registerAccount: appState.registerAccount,
            signOut: appState.signOut,
          ),
        ),
        Divider(
          height: 8,
          thickness: 1,
          indent: 8,
          endIndent: 8,
          color: Colors.grey,
        ),
        Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loginState == ApplicationLoginState.loggedIn) ...[
                  Training(),
                ]
              ],
            )
        )
        ],
      ),
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;

        _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _guestBookMessages = [];
          snapshot.docs.forEach((document) {
            _guestBookMessages.add(
              GuestBookMessage(
                name: document.data()['name'],
                message: document.data()['text'],
                kcal: document.data()['kcal'],
                pace: document.data()['pace'],
                speed: document.data()['speed'],
                distance: document.data()['distance'],
                time: document.data()['time'],
                date: document.data()['date'],
              ),
            );
          });
          notifyListeners();
        });

      } else {
        _loginState = ApplicationLoginState.loggedOut;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void verifyEmail(
      String email,
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      var methods =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signInWithEmailAndPassword(
      String email,
      String password,
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void registerAccount(String email, String displayName, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // ignore: deprecated_member_use
      await credential.user!.updateProfile(displayName: displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
  Future<DocumentReference> addMessageToGuestBook(String message, kcal, pace, speed, distance, time, date) {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('guestbook').add({
      'date':date,
      'time':time,
      'distance':distance,
      'speed': speed,
      'pace': pace,
      'kcal': kcal,
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}

class GuestBookMessage {
  GuestBookMessage({required this.name, required this.message, required this.kcal, required this.pace, required this.speed, required this.distance, required this.time, required this.date});
  final String name;
  final String message;
  final String kcal;
  final String pace;
  final String speed;
  final String distance;
  final String time;
  final String date;
}

class GuestBook extends StatefulWidget {
  GuestBook({required this.addMessage, required this.messages, required this.kcal, required this.pace, required this.speed, required this.distance, required this.time, required this.date, required List<String> trainingList}) : this.trainingList = trainingList;
  final FutureOr<void> Function(String message, String kcal, String pace, String speed, String distance, String time, String date) addMessage;
  final List<GuestBookMessage> messages;
  final String kcal;
  final String pace;
  final String speed;
  final String distance;
  final String time;
  final String date;
  final List<String> trainingList;

  @override
  _GuestBookState createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // to here.
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                SizedBox(width: 8),
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate())
                        _controller.text = widget.kcal;
                        widget.addMessage(_controller.text, widget.kcal.toString(), widget.pace.toString(), widget.speed.toString(), widget.distance.toString(), widget.time.toString(), widget.date.toString());
                    _controller.clear();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('WYŚLIJ DO BAZY DANYCH'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GuestBook2 extends StatefulWidget {
  GuestBook2({required this.addMessage, required this.messages, required this.kcal, required this.pace, required this.speed, required this.distance, required this.time, required this.date, required List<String> trainingList}) : this.trainingList = trainingList;
  final FutureOr<void> Function(String message, String kcal, String pace, String speed, String distance, String time, String date) addMessage;
  final List<GuestBookMessage> messages;
  final String kcal;
  final String pace;
  final String speed;
  final String distance;
  final String time;
  final String date;
  final List<String> trainingList;

  @override
  _GuestBookState2 createState() => _GuestBookState2();
}


class _GuestBookState2 extends State<GuestBook2> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                SizedBox(width: 8),
              ],
            ),
          ),
        ),
        Table(
            border: TableBorder(horizontalInside: BorderSide(width: 0.7, color: Colors.grey, style: BorderStyle.solid)),
            children: [
              for (var message in widget.messages)
                //if (message.name == FirebaseAuth.instance.currentUser!.displayName)
                  TableRow(children: [

                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new Text(message.name),
                            //new Text(message.message),
                          ],
                        ),
                      ),


                      TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Text(message.kcal),
                            ]
                          )
                      ),
                      TableCell(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                            new Text(message.pace),
                            ]
                          )
                        ),

                      TableCell(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                new Text(message.speed),
                              ]
                          )
                      ),
                      TableCell(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                new Text(message.distance),
                              ]
                          )
                      ),

                      TableCell(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                new Text(message.time),
                              ]
                          )
                      ),

                      TableCell(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                            new Text(message.date),
                            ]
                          )
                        )]
              )],
        )]
    );
  }
}


class Training extends StatefulWidget {
  @override
  _TrainingState createState() => _TrainingState();
}

class _TrainingState extends State<Training>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StyledButton(
          child: Row(
            children:[
              Icon(Icons.send),
              SizedBox(width:4),
              Text('Trening'),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => (TrainingRoute())),
            );
          },
        ),
        StyledButton(
          child: Row(
            children:[
              Icon(Icons.send),
              SizedBox(width:4),
              Text('Historia'),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => (HistoryRoute())),
            );
          },
        ),
        StyledButton(
            child: Row(
              children:[
                Icon(Icons.send),
                SizedBox(width:4),
                Text('Ustawienia'),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (SettingsRoute())),
              );
            },
        ),
      ],
    );
  }
}