import 'package:flutter/material.dart';
import 'package:list/screens/home/home.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {

    //  UserSettings userSettings = Provider.of<UserSettings>(context);

    return Scaffold(
      body: Center(
          child: IconButton(
        icon: Icon(Icons.ac_unit),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        },
      )),
    );
  }
}
