import 'package:flutter/material.dart';
import 'package:list/models/user_settings.dart';
import 'package:list/screens/actual_list/actual_list.dart';
import 'package:list/services/auth.dart';
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

    final _formKey = GlobalKey<FormState>();
    String inputName;
    
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          RotatedBox(
            quarterTurns: 2,
            child: IconButton(
              color: Colors.black,
              iconSize: 32.0,
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await AuthService().signOut();
              },
              tooltip: 'abmelden',
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: availableListsStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return AvailableListTile(listName: snapshot.data.docs[index].data()["listName"], listId: snapshot.data.docs[index].id, userSettings: widget.userSettings);
            }
          ) : Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Neue Liste erstellen'),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Wie soll die Liste heißen?'),
                    validator: (val) => val.isEmpty ? '???' : null,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    onChanged: (String value) {
                      inputName = value;
                    },
                  ),
                ),
                actions: [
                  IconButton(
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 30),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        await DatabaseServicesWOuid().createNewList(inputName.trim(), widget.userSettings.email);
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(Icons.add_circle, size: 40, color: Colors.teal[200],),
                  )
                ],
              );     
            }
          );
        },
        child: Icon(Icons.add, size: 40, color: Colors.white),
        backgroundColor: Colors.teal[200],
      ),
    );
  }
}




class AvailableListTile extends StatelessWidget {

  final String listName;
  final String listId;
  final UserSettings userSettings;
  AvailableListTile({ this.listName, this.listId, this.userSettings });


  @override
  Widget build(BuildContext context) {


    String inputEmail;
    final _formKey = GlobalKey<FormState>();


    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ActualList(listId: listId, listName: listName, userSettings: userSettings,)
        ));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        color: Colors.white70,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Row(
              children: [
                Text('$listName', style: TextStyle(fontSize: 25),)
              ],
            ),
            IconButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      // title: Text('neuer Eintrag'),
                      content: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Email des Teilnehmers'),
                          validator: (val) => val.isEmpty ? '???' : null,
                          autofocus: true,
                          onChanged: (String value) {
                            inputEmail = value;
                          },
                        ),
                      ),
                      actions: [
                        IconButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 30, 30),
                          onPressed: () async {
                            if(_formKey.currentState.validate()) {
                              await DatabaseServicesWOuid().addMember(inputEmail.trim(), listId);
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(Icons.add_circle, size: 40, color: Colors.teal[200],),
                        )
                      ],
                    );  
                  }
                );
              },
              icon: Icon(Icons.group_add),
            ),
          ],
        ),
      ),
    );
  }
}

