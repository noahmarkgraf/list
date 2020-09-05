import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list/models/purchase.dart';
import 'package:list/models/user_settings.dart';
import 'package:list/screens/home/purchase_tile.dart';
import 'package:list/services/database.dart';
import 'package:list/shared/datetime.dart';


class PurchaseList extends StatefulWidget {
  @override
  _PurchaseListState createState() => _PurchaseListState();
}

class _PurchaseListState extends State<PurchaseList> {
  @override
  Widget build(BuildContext context) {

    UserSettings userSettings = Provider.of<UserSettings>(context);
    final purchases = Provider.of<List<Purchase>>(context) ?? [];

    final _formKey = GlobalKey<FormState>();


    String inputName;
    

    return Scaffold(
      body: ListView.builder(
        itemCount: purchases.length,
        itemBuilder: (context, index) {
          return PurchaseTile(purchase: purchases[index]);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                // title: Text('neuer Eintrag'),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
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
                        Purchase purchase = Purchase();
                        purchase.userName = userSettings.name;
                        purchase.name = inputName;
                        purchase.date = MyDateTime().convertString(DateTime.now());
                        await DatabaseService(uid: userSettings.uid).purchasesUpdate(purchase);
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