import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:run4fun/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'dart:async';
import 'login_route.dart';

class HistoryRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HistoryState();
  }
}

class HistoryState extends State<HistoryRoute> {
}

/***
class view extends StatefulWidget {
  @override
  _view createState() => _view();
}

class _view extends State<view> {
  Future getPosts() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('data').getDocuments();
    return qn.documents;
  }


  DateTime Date = DateTime.now();
  var i = 0;
  Future<void> _Date(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: Date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != Date)
      setState(() {
        Date = picked;
      });

  }
  String dropdownValue = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xFF11249F),
              title: new Text("VIEW DATA",
                style: new TextStyle(color: Colors.white),),
            ),
            body: SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          children: <Widget>[
                            SizedBox(width: 10,),
                            Container(
                              child: Text ('Select Factory',style: TextStyle(
                                  fontSize: 14.5,
                                  fontFamily: "Quando",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple
                              ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Color(0xFFE5E5E5),
                                ),
                              ),
                              child:Row(
                                  children: <Widget>[
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: DropdownButton(value: dropdownValue,
                                        isExpanded: true,
                                        icon: Icon(Icons.arrow_downward),
                                        style: TextStyle(fontSize: 13,
                                            fontFamily: "Quando",
                                            fontWeight: FontWeight.w500,
                                            color: Colors.deepPurple),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            dropdownValue = newValue;
                                          });
                                        },
                                        items: <String>['','Vapi', 'Masat']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ]
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Column(

                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(width: 10,),
                                Container(

                                  child: Text('Date',style: TextStyle(
                                      fontSize: 14.5,
                                      fontFamily: "Quando",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple
                                  ),
                                  ),

                                ),
                                SizedBox(width: 80,),
                                Text("${Date.toLocal()}".split(' ')[0],style: TextStyle(
                                    fontSize: 14.5,
                                    fontFamily: "Quando",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple
                                ),),
                                SizedBox(width: 20.0,),
                                RaisedButton(

                                  onPressed: () => _Date(context),
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(0.0),
                                  child:Container(
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xFF0D47A1),
                                              Color(0xFF1976D2),
                                              Color(0xFF42A5F5),
                                            ]
                                        )
                                    ),
                                    padding: const EdgeInsets.all(10.0),
                                    child:
                                    const Text('Select Date', style: TextStyle(fontSize: 14)),
                                  ) ,
                                ),
                              ],
                            ),
                            SizedBox(height: 30,),
                            Container(
                                child: FutureBuilder(
                                    future: getPosts(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(
                                          child: Text('Loading...',style: TextStyle(
                                              fontSize: 14.5,
                                              fontFamily: "Quando",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple
                                          ),),

                                        );
                                      }
                                      else {
                                        String formattedDate = DateFormat('yyyy-MM-dd').format(Date);
                                        return new SizedBox(
                                            height: 1000,
                                            child :GridView.builder(
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: (Orientation == Orientation.landscape) ? 7 : 7),
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (context, index) {
                                                  if (snapshot.data[index].data['Date'] ==
                                                      formattedDate &&
                                                      snapshot.data[index].data['Plant'] ==
                                                          dropdownValue) {
                                                    i++;
                                                    return DataTable(
                                                      columns: [
                                                        DataColumn(
                                                            label: Text(
                                                              "Work Centre",style: TextStyle(
                                                                fontStyle:FontStyle.italic
                                                            ),
                                                            )
                                                        ),
                                                        DataColumn(
                                                            label: Text(
                                                              "Work Centre",style: TextStyle(
                                                                fontStyle:FontStyle.italic
                                                            ),
                                                            )
                                                        ),
                                                        DataColumn(
                                                            label: Text(
                                                              "Work Centre",style: TextStyle(
                                                                fontStyle:FontStyle.italic
                                                            ),
                                                            )
                                                        ),
                                                        DataColumn(
                                                            label: Text(
                                                              "Work Centre",style: TextStyle(
                                                                fontStyle:FontStyle.italic
                                                            ),
                                                            )
                                                        ),
                                                        DataColumn(
                                                            label: Text(
                                                              "Work Centre",style: TextStyle(
                                                                fontStyle:FontStyle.italic
                                                            ),
                                                            )
                                                        ),
                                                        DataColumn(
                                                            label: Text(
                                                              "Work Centre",style: TextStyle(
                                                                fontStyle:FontStyle.italic
                                                            ),
                                                            )
                                                        ),
                                                        DataColumn(
                                                            label: Text(
                                                              "Work Centre",style: TextStyle(
                                                                fontStyle:FontStyle.italic
                                                            ),
                                                            )
                                                        ),
                                                      ],
                                                      rows: [
                                                        DataRow(
                                                          cells: <DataCell>[
                                                            DataCell(Text('Sarah')),
                                                            DataCell(Text('19')),
                                                            DataCell(Text('Student')),
                                                            DataCell(Text('Sarah')),
                                                            DataCell(Text('Sarah')),
                                                            DataCell(Text('Sarah')),
                                                            DataCell(Text('Sarah')),
                                                          ],
                                                        )
                                                      ],
                                                    );
                                                  }
                                                  else {
                                                    return Container();
                                                  }
                                                }
                                            ));
                                      }
                                    }  )
                            )
                          ]
                      )
                    ]
                )
            )
        ));
  }
}
Problem : Screenshot

PS: Data written in row is temporary I will change it later to get data from firestore, I need 7 cols & n no of rows just like excel sheet

firebase
flutter
dart
google-cloud-firestore
datatables
Share
Improve this question
Follow
*/