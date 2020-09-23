import 'package:flutter/material.dart';
import 'package:list/models/user_settings.dart';
import 'package:list/services/database.dart';


class MainScreen extends StatefulWidget {

  final UserSettings userSettings;
  MainScreen({ this.userSettings });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Stream availableListsStream;

  @override
  void initState() {
    DatabaseService(uid: widget.userSettings.uid).getAvailableLists(widget.userSettings.email).then((val){
      setState(() {
        availableListsStream = val;
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: availableListsStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return AvailableListTile(listName: snapshot.data.docs[index].data()["listName"]);
            }
          ) : Container();
        },
      )
    );
  }
}


class AvailableListTile extends StatelessWidget {

  final String listName;
  AvailableListTile({ this.listName });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: ListTile(
          leading: Text('$listName'),
        ),
      ),
    );
  }
}

