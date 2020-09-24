import 'package:flutter/material.dart';
import 'package:list/models/user_settings.dart';
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
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text(widget.listName, style: TextStyle(color: Colors.black),),
          elevation: 0.0,
          bottom: TabBar(
            labelPadding: EdgeInsets.only(bottom: 12),
            tabs: [
              Text('zu erledigen', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              Text('erledigt', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
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