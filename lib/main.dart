import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check Connection Auto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Check Connection Auto'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription? internetConnection;
  bool isOffline = false;
  //set variable for Connectivity subscription listener
  @override
  void initState() {
    internetConnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isOffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isOffline = false;
        });
      }
    }); // using this listiner, you can get the medium of connection as well.

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    internetConnection!.cancel();
    //cancel internent connection subscription after you are done
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //this is your content
              margin: const EdgeInsets.all(30),
              width: double.infinity,
              child: Center(
                child: Text(
                  "Check Connections",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              child: errmsg("No Internet Connection Available", isOffline),
              //to show internet connection message on isOffline = true.
            ),
          ],
        ),
      ),
    );
  }

  Widget errmsg(String text, bool show) {
    //error message widget.
    if (show == true) {
      //if error is true then show error message box
      return Container(
        padding: EdgeInsets.all(10.00),
        margin: EdgeInsets.only(bottom: 10.00),
        color: Colors.red,
        child: Row(children: [
          Container(
            margin: EdgeInsets.only(right: 6.00),
            child: Icon(Icons.info, color: Colors.white),
          ), // icon for error message

          Text(text, style: TextStyle(color: Colors.white)),
          //show error message text
        ]),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(10.00),
        margin: EdgeInsets.all(20),
        color: Colors.green,
        child: Row(children: [
          Container(
            margin: EdgeInsets.only(right: 6.00),
            child: Icon(Icons.info, color: Colors.white),
          ), // icon for error message

          Text('You have Internet', style: TextStyle(color: Colors.white)),
          //show error message text
        ]),
      );
      //if error is false, return empty container.
    }
  }
}
