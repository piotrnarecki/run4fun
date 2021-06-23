import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'history_route.dart';
import 'widgets.dart';
import 'authentication.dart';
import 'package:intl/intl.dart';
import 'training_route.dart';
import 'settings_route.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Widżet będący głównym ekranem, który pojawia się podczas rozruchu aplikacji
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

// Klasa HomePage oraz _HomePageState zawierają w sobie funkcjonalność dotyczącą
// wyświetlania informacji na głównym ekranie, logowania na zarejestrowane konto
// oraz logowania przy użyciu konta Google
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Zmienne wykorzystywane podczas logowania przy użyciu konta Google.
  // Do obsługi konta Google użyto biblioteki "google_sign_in".
  bool _isLoggedIn = false;
  late GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  // Metoda build zastępuje poddrzewo poniżej widżetu _HomePageState widżetem
  // zwróconym przez tę metodę, aktualizując istniejące poddrzewo lub usuwając
  // poddrzewo i powiększając nowe poddrzewo.
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

        SizedBox(height: 8),
        IconAndDetail(Icons.calendar_today, formattedDate),
        // Tworzenie wystąpienia widgetu Authentication i umieszczenie go w
        // widgecie Consumer. Widżet Consumer to typowy sposób, w jaki pakiet
        // provider może zostać użyty do odbudowania części drzewa
        // gdy zmienia się stan aplikacji
        Consumer<ApplicationState>(
          builder: (context, appState, _) => Authentication(
            // Zmienne wykorzystywane podczas logowania na konto.
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
            // Klasa Container zawierająca funkcjonalność dotyczącą konta Google.
            Container(
              child: _isLoggedIn
                  ? Column(
                children: [
                  // Wyświetlanie zdjęcia profilowego konta Google,
                  // imienia użytkownika oraz jego adresu email
                  Image.network(_userObj.photoUrl!),
                  Text(_userObj.displayName!),
                  Text(_userObj.email),
                  TextButton(
                      onPressed: () {
                        _googleSignIn.signOut().then((value) {
                          setState(() {
                            _isLoggedIn = false;
                          });
                        }).catchError((e) {});
                      },
                      child: Text("Logout")
                  ),
                ],
              )
              // Klasa Center z przyciskiem logowania do konta Google
                  : Center(
                child: ElevatedButton(
                  child: Text("Login with Google"),
                  onPressed: () {
                    _googleSignIn.signIn().then((userData) {
                      setState(() {
                        _isLoggedIn = true;
                        _userObj = userData!;
                      });
                      // Podczas wciśnięcia przycisku "Login with Google"
                      // funkcja push należąca do klasy Navigator, przenosi
                      // użytkownika do okna z treningiem
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Training()),
                      );
                    }).catchError((e) {
                      print(e);
                    });

                  },
                ),
              ),
            ),
        // Sprawdzanie czy użytkownik jest zalogowany, jeśli tak -
        // przeniesienie do okna z treningiem
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
  // klasa Future służy do reprezentowania potencjalnej wartości lub błędu,
  // który będzie dostępny w pewnym momencie w przyszłości. W tym przypadku są to
  // zmienne należące do klasy GuestBookMessage, których wartości są wysyłane
  // do bazy danych w aplikacji Firebase (timestampy). Następuje tutaj
  // zakolejkowana subksrypcja dotycząca kolekcji dokumentów, gdy użytkownik się zaloguje.
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
  // W sekcji ApplicationState są zdefiniowane stany i gettery.
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  // Funkcja zapoczątkowująca proces logowania się
  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  // Funkcja sprawdzająca poprawność podane adresu email przez użytkownika.
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

  // Funkcja wywoływana podczas logowania z użyciem adresu mailowego i hasła.
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

  // Funkcja wywoływana podczas anulowania procesu rejestracji.
  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  // Funkcja wywoływana podczas procesu rejestracji nowego konta.
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

  // Funkcja, która jest używana w czasie kiedy użytkownik wylogowuje się z konta.
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
      // FirebaseAuth.instance.currentUser.uid to odniesienie do
      // automatycznie wygenerowanego unikalnego identyfikatora, który
      // widżet Authentication nadaje wszystkim zalogowanym użytkownikom.
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}

//Klasa tworząca obiekt z danymi dotyczącymi parametrów biegu i użytkownika
// wysyłany do bazy danych
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

//Klasa dodająca informacje do bazy danych
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

// Zawartość metody build opakowana jest widżetem Column. Tworzona jest tutj
// instancja widżetu Form, aby interfejs użytkownika mógł sprawdzić,
// czy wiadomość rzeczywiście zawiera jakąś treść, i pokazać użytkownikowi
// komunikat o błędzie, jeśli go nie ma. Sposób sprawdzania poprawności formularza
// obejmuje dostęp do stanu formularza "za" formularzem, do tego celu użyto
// klasy GlobalKey, następnie na końcu elementów potomnych widżetu Column dodawany jest
// widżet Row z przyciskiem wysyłającym zawartość formularza do bazy danych.
class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

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

//Klasa odpowiadająca za wyświetlanie danych w postaci wykresu i tabeli
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

// W klasie GuestBookState2 zawarte są wszystkie widżety dotyczące wyświetlania
// danych dotyczących historii treningów.
class _GuestBookState2 extends State<GuestBook2> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  late List<GDPData> _chartData;
  get trainingModel => trainingModel;

  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 10,
          child:
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
        ),

        // Widżet Container z zawartością służącą do rysowania wykresu.
        Container(
          height: 300,
          width: 1000,
          child:
          Scaffold(
            body: SfCartesianChart(
              series: <ChartSeries>[
                ColumnSeries<GDPData, String>(
                  dataSource: _chartData,
                  xValueMapper: (GDPData gdp,_)=>gdp.date,
                  yValueMapper: (GDPData gdp,_)=>gdp.gdp
                )
              ],
              primaryXAxis: CategoryAxis(),
            ),
          ),
        ),
        Container(
          height: 5000,
          width:1000,
          child:
          // Widżet DataTable zawiera zmienne dotyczące parametrów treningu.
          DataTable(
            dataRowHeight: 16,
            columnSpacing: 22,
            columns: [
              DataColumn(label: Expanded(child: Text('Energia\n[kcal]',textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('Prędkość\n[m/s]',textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('Dystans\n[m]',textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('Czas\n[s]',textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('Data\n[d/m]',textAlign: TextAlign.center))),
            ],
            rows: [
              for (var message in widget.messages)
                if (message.name == FirebaseAuth.instance.currentUser!.displayName)
                  DataRow(cells:[
                    DataCell(Text(message.kcal,textAlign: TextAlign.center), onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context) => (SettingsRoute())),);}),
                    DataCell(Text(message.speed,textAlign: TextAlign.center)),
                    DataCell(Text(message.distance,textAlign: TextAlign.center)),
                    DataCell(Text(message.time,textAlign: TextAlign.center)),
                    DataCell(Text((message.date.substring(8, max(0, message.date.length - 16)) + '/' + message.date.substring(5, max(0, message.date.length - 19))),textAlign: TextAlign.center)),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }
  List<GDPData> getChartData(){
    final List<GDPData> chartData = [];
    for (var message in widget.messages) {
      if (message.name == FirebaseAuth.instance.currentUser!.displayName)
        chartData.add(GDPData(double.parse(message.distance),
            (message.date.substring(10, max(0, message.date.length - 10)) +'\n'+ message.date.substring(8, max(0, message.date.length - 16)) + '/' + message.date.substring(5, max(0, message.date.length - 19)))));
    }
    return chartData;
  }
}

//Klasa tworząca obiekty dodawane do wykresu
class GDPData {
  GDPData(this.gdp, this.date);
  final double gdp;
  final String date;
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