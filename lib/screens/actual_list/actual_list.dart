import 'package:flutter/material.dart';
import 'package:list/models/user_settings.dart';
import 'package:list/screens/actual_list/list_member_settings.dart';
import 'package:list/screens/actual_list/purchase_tab.dart';
import 'package:list/services/database.dart';

class ActualList extends StatefulWidget {

  final String listId;
  final String listName;
  final UserSettings userSettings;
  ActualList({ this.listId, this.listName, this.userSettings });

  @override
  _ActualListState createState() => _ActualListState();
}

class _ActualListState extends State<ActualList> {

  Stream purchaseListStream;
  Stream purchaseDoneListStream;

  @override
  void initState() {
    DatabaseServicesWOuid().getPurchaseList(widget.listId).then((val){
      setState(() {
        purchaseListStream = val;
      });
    });
    DatabaseServicesWOuid().getPurchaseDoneList(widget.listId).then((val){
      setState(() {
        purchaseDoneListStream = val;
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          actions: [
            IconButton(
              onPressed: (){
                 Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ListMemberSettings(userSettings: widget.userSettings, listId: widget.listId,),
                ));
              },
              icon: Icon(Icons.group_add, color: Colors.black,),
              iconSize: 30,
            ),
          ],
          backgroundColor: Colors.teal[200],
          title: Text(widget.listName, style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),),
          elevation: 0.0,
          bottom: TabBar(
            indicatorColor: Colors.black,
            // labelColor: Colors.teal[400],
            // unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)),
              color: Colors.white),
            tabs: [
              Container(color: Color.fromRGBO(255, 0, 0, 0), padding: EdgeInsets.fromLTRB(20, 10, 20, 12), child: Text('zu erledigen', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400))),
              Container(padding: EdgeInsets.fromLTRB(40, 10, 40, 12), child: Text('erledigt', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400))),
            ]),
        ),
        body: TabBarView(children: [
          PurchaseTab(purchaseListStream: purchaseListStream, userSettings: widget.userSettings, listId: widget.listId),
          PurchaseDoneTab(purchaseDoneListStream: purchaseDoneListStream, userSettings: widget.userSettings, listId: widget.listId)
        ],),
      ),
    );
  }
}