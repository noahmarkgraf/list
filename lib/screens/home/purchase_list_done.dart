import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list/models/purchase_done.dart';
import 'package:list/screens/home/puchase_tile_done.dart';

class PurchaseListDone extends StatefulWidget {
  @override
  _PurchaseListDoneState createState() => _PurchaseListDoneState();
}

class _PurchaseListDoneState extends State<PurchaseListDone> {
  @override
  Widget build(BuildContext context) {


    final purchasesDone = Provider.of<List<PurchaseDone>>(context) ?? [];



    return Scaffold(
      body: ListView.builder(
        itemCount: purchasesDone.length,
        itemBuilder: (context, index) {
          return PurchaseDoneTile(purchaseDone: purchasesDone[index]);
        },
      ),
    );
  }
}