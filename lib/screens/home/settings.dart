import 'package:flutter/material.dart';
import 'package:list/models/user_settings.dart';
import 'package:list/services/database.dart';
import 'package:list/shared/constants.dart';

class SettingsScreen extends StatefulWidget {

  final UserSettings userSettings;

  SettingsScreen({ this.userSettings });

  @override
  _SettingsScreenState createState() => _SettingsScreenState(initUserSettings: userSettings);
}

class _SettingsScreenState extends State<SettingsScreen> {

  UserSettings initUserSettings;

  _SettingsScreenState({ this.initUserSettings });
  

  UserSettings userSettings;
  bool loaded = false;
  TextEditingController nameTextController = TextEditingController();
  String useruid;

  void load() async {
    if (!loaded) {
      userSettings = initUserSettings;
      loaded = true;
      setState(() {
        nameTextController.text = userSettings.name;
        useruid = userSettings.uid;    
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    load();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.tealAccent[100], Colors.pink[100]]),
          ),
        ),
        title: Text('Einstellungen', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.brown[400],
      ),
      body: ScrollableScreen(page: _settingsScreen()).build(),
    );
  }


  Widget _settingsScreen() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: Form(
        child: Column(
          children: [
            SizedBox(height: 25.0),
            TextFormField(
              controller: nameTextController,
                onChanged: (val) {
                  setState(() => userSettings.name = val);
                },
                decoration: textInputDecoration.copyWith(
                    hintText: 'Name',
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.black))),
            SizedBox(height: 25.0),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                ),
              color: Colors.teal[200],
              onPressed: () async {
                await DatabaseService(uid: userSettings.uid)
                    .updateUserSettings(userSettings);
                Navigator.pop(context, userSettings);
              },
              child: Text('speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
