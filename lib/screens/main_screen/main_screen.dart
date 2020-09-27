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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Listen', style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w400)),
        centerTitle: true,
        backgroundColor: Colors.teal[200],
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
              return AvailableListTile(listName: snapshot.data.docs[index].data()["listName"], listId: snapshot.data.docs[index].id, userSettings: widget.userSettings,
                                    listBy: snapshot.data.docs[index].data()["adminName"]);
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
                        await DatabaseServicesWOuid().createNewList(inputName.trim(), widget.userSettings.email, widget.userSettings.name);
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
  final String listBy;
  AvailableListTile({ this.listName, this.listId, this.userSettings, this.listBy });



  @override
  Widget build(BuildContext context) {


    String shortListName = listName;



    if(listName.length > 20) {
      shortListName = listName.substring(0,19) + '...';
    }

    return GestureDetector(
      onLongPress: () async { 
        listBy == userSettings.name ? _renameList(context) : _leaveList(context);
      },
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ActualList(listId: listId, listName: listName, userSettings: userSettings,)
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,),
        margin: EdgeInsets.fromLTRB(10, 15, 10, 0), 
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.format_list_bulleted),
            Column(
              children: [
                SizedBox(height: 10,),
                Text('$shortListName', style: TextStyle(fontSize: 25)),
                SizedBox(height: 5,),
                Text('von $listBy'),
                SizedBox(height: 10,),
              ],
            ),
            listBy == userSettings.name ? IconButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      // title: Text('neuer Eintrag'),
                      content: Text('Liste endgültig löschen?'),
                      actions: [
                        FlatButton(
                          child: Text('Abbrechen'),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text('Löschen'),
                          onPressed: () async {
                            await DatabaseServicesWOuid().deleteList(listId);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );  
                  }
                );
              },
              icon: Icon(Icons.delete, color: Colors.red,),
            ) : IconButton(
              onPressed: (){},
              icon: Icon(Icons.delete, color: Color.fromRGBO(0, 0, 0, 0),),
            ),
          ],
        ),
      ),
    );
  }




  _renameList(BuildContext context) async {

    final _formKey = GlobalKey<FormState>();

    String inputName;


    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Name ändern'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (val) => val.isEmpty ? '???' : null,
              initialValue: listName,
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
                  await DatabaseServicesWOuid().changelistName(listId, inputName.trim());
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.check, size: 40, color: Colors.teal[200],),
            )
          ],
        );     
      }
    );      
  }



  _leaveList(BuildContext context) async {

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Liste endgültig verlassen?'),
          actions: [
            FlatButton(
              onPressed: () async {
                  await DatabaseServicesWOuid().deleteMember(userSettings.email, listId);
                  Navigator.pop(context);
              }, 
              child: Text('Verlassen', style: TextStyle(color: Colors.red),),
            )
          ],
        );     
      }
    );
        
  }
}

