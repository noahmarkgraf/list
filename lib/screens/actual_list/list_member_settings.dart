import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:list/models/user_settings.dart';
import 'package:list/services/database.dart';


class ListMemberSettings extends StatefulWidget {

  final String listId;
  final UserSettings userSettings;

  ListMemberSettings({ this.listId, this.userSettings });
  @override
  _ListMemberSettingsState createState() => _ListMemberSettingsState();
}

class _ListMemberSettingsState extends State<ListMemberSettings> {


  Stream listMemberStream;

   @override
  void initState() {
    DatabaseServicesWOuid().getListMember(widget.listId).then((val){
      setState(() {
        listMemberStream = val;
      });
    });
    super.initState();
  }


  List<String> memberList;  


  final _formKey = GlobalKey<FormState>();

  String inputName;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('Teilnehmer', style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400)),
        backgroundColor: Colors.teal[200],
      ),
      body: StreamBuilder(
        stream: listMemberStream,
        builder: (context, snapshot){
          return snapshot.hasData ? _memberList(snapshot, context) : Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Email hinzufügen'),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (val) => val.isEmpty ? '???' : null,
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
                        await DatabaseServicesWOuid().addMember(inputName.trim().toLowerCase(), widget.listId);
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

  Widget _memberList(AsyncSnapshot<dynamic> snapshot, BuildContext context) {
    
    DocumentSnapshot doc = snapshot.data;
    Map<String, dynamic> documentFields = doc.data();
    memberList = List.from(documentFields["member"]);

    return ListView.builder(
      itemCount: memberList.length,
      itemBuilder: (context, index){
        return ListMemberTile(member: memberList[index], userSettings: widget.userSettings, listId: widget.listId, memberList: memberList,);
      }
    );  
  }
}



class ListMemberTile extends StatelessWidget {

  final String listId;
  final String member;
  final UserSettings userSettings;
  final List memberList;
  ListMemberTile({ this.listId, this.member, this.userSettings, this.memberList });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,),
      margin: EdgeInsets.fromLTRB(10, 15, 10, 0), 
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.person),
          Column(
            children: [
              SizedBox(height: 5,),
              Text('$member', style: TextStyle(fontSize: 15)),
              SizedBox(height: 5,),
            ],
          ),
          member == memberList[0] ? IconButton(onPressed: (){}, icon: Icon(Icons.home, color: Colors.black)) :
          memberList[0] == userSettings.email ? IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text('Teilnehmer endgültig löschen?'),
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
                          await DatabaseServicesWOuid().deleteMember(member, listId);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );  
                }
              );
            },
            icon: Icon(Icons.delete, color: Colors.red,),
          ): IconButton(onPressed: (){}, icon: Icon(Icons.delete), color: Color.fromRGBO(0, 0, 0, 0),),
        ],
      ),
    );
  }
}