import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:list/models/user.dart';
import 'package:list/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:list/services/auth.dart';
import 'package:list/shared/loading.dart';
import 'package:list/models/user_settings.dart';


void main() => runApp(App());


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        //future: Future.delayed(Duration(seconds: 10)),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(
              child: Text('Fehler........'),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Provider<UserSettings>(
              create: (_) => UserSettings(),
              child: StreamProvider<MyUser>.value(
                initialData: MyUser(),
                value: AuthService().user,
                child: Container(
                  child: Wrapper(),
                ),
              ),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Loading();
        },
      ),
    );
  }
}
