import 'package:flutter/material.dart';
import 'package:list/models/user.dart';
import 'package:list/models/user_settings.dart';
import 'package:list/screens/main_screen/main_screen.dart';
import 'package:list/services/auth.dart';
import 'package:list/services/database.dart';
import 'package:list/shared/loading.dart';
import 'package:provider/provider.dart';

class LoadUserSettings extends StatelessWidget {


  final AuthService _auth = AuthService();

  Future<UserSettings> loadUserSettings() async {
    final MyUser myUser = _auth.getCurrentUser();
    return userSettings = await DatabaseService(uid: myUser.uid).readUserSettings();
  }

  UserSettings userSettings;



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSettings>(
      future: loadUserSettings(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text('Fehler'),
          );
        }

        // Once complete, show your application
        if (snapshot.hasData) {
          userSettings = Provider.of<UserSettings>(context);
          userSettings.name = snapshot.data.name;
          userSettings.uid = snapshot.data.uid;
          userSettings.email = snapshot.data.email; 
 
          return MainScreen(userSettings: userSettings);   
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}