import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list/models/purchase.dart';
import 'package:list/models/purchase_done.dart';
import 'package:list/models/user_settings.dart';
import 'package:list/shared/datetime.dart';

class DatabaseService {


  final String uid;
  DatabaseService({ this.uid });

  //collection reference userSettings
  final CollectionReference userSettingsCollection = FirebaseFirestore.instance.collection('userSettings');




  //UserSetting update
  Future updateUserSettings(UserSettings userSettings) async {
    if(userSettings == null){
      userSettings = UserSettings();
    } 
    return await userSettingsCollection.doc(uid).set({
      'name': userSettings.name,
      'uid': userSettings.uid,
      'email': userSettings.email,
    });
  }


  //UserSettings read
  Future readUserSettings() async {
    DocumentSnapshot result = await userSettingsCollection.doc(uid).get();
    Map<String, dynamic> data = result.data();
    UserSettings user = UserSettings();
    user.name = data['name'];
    user.uid = data['uid'];
    user.email = data['email'];
    return user;
  }


  //colllection reference purchaseCollection
  final CollectionReference purchaseCollection = FirebaseFirestore.instance.collection('purchases');


  //purchasesUpdate
  Future purchasesUpdate(Purchase purchase) async {
    if(purchase == null){
      purchase = Purchase();
    } 
    return await purchaseCollection.doc().set({
      'name': purchase.name,
      'userName': purchase.userName,
      'date': purchase.date,
    });
  }


  //purchase list 
  List<Purchase> _purchaseListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      Map<String, dynamic> data = doc.data();
      return Purchase(
        name: data['name'],
        userName: data['userName'],
        date: data['date'],
        id: doc.id,
      );
    }).toList();
  }


  //get purchase stream
  Stream<List<Purchase>> get purchases {
    return purchaseCollection.snapshots()
      .map(_purchaseListFromSnapshot);
  }


  //delete purchase
  Future deletePurchase(docId) async {
    return await purchaseCollection.doc(docId).delete();
  }








  //colllection reference purchaseCollection
  final CollectionReference purchaseDoneCollection = FirebaseFirestore.instance.collection('purchasesDone');


  //purchasesUpdate
  Future purchasesDoneUpdate(PurchaseDone purchaseDone) async {
    if(purchaseDone == null){
      purchaseDone = PurchaseDone();
    } 
    return await purchaseDoneCollection.doc().set({
      'name': purchaseDone.name,
      'userName': purchaseDone.userName,
      'date': purchaseDone.date,
    });
  }


  //purchase list 
  List<PurchaseDone> _purchaseDoneListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      Map<String, dynamic> data = doc.data();
      return PurchaseDone(
        name: data['name'],
        userName: data['userName'],
        date: data['date'],
        id: doc.id,
      );
    }).toList();
  }
  

  //get purchase stream
  Stream<List<PurchaseDone>> get purchasesDone {
    return purchaseDoneCollection.snapshots()
      .map(_purchaseDoneListFromSnapshot);
  }


  //delete purchase
  Future deletePurchaseDone(docId) async {
    return await purchaseDoneCollection.doc(docId).delete();
  }




  // push purchase to puchaseDone
  Future closePurchase(Purchase purchase, String userSettingsUserName) async {
    await deletePurchase(purchase.id);
    PurchaseDone purchaseDone = PurchaseDone();
    String _date = MyDateTime().convertString(DateTime.now());
    purchaseDone.name = purchase.name;
    purchaseDone.id = purchase.id;
    purchaseDone.date = _date;
    purchaseDone.userName = userSettingsUserName;
    return await purchasesDoneUpdate(purchaseDone);
  }



  // push purchaseDone to purchase
  Future closePurchaseDone(PurchaseDone purchaseDone,  String userSettingsUserName) async {
    await deletePurchaseDone(purchaseDone.id);
    Purchase purchase = Purchase();
    String _date = MyDateTime().convertString(DateTime.now());
    purchase.name = purchaseDone.name;
    purchase.id = purchaseDone.id;
    purchase.date = _date;
    purchase.userName = userSettingsUserName;
    return await purchasesUpdate(purchase);
  }





  final CollectionReference listCollection = FirebaseFirestore.instance.collection('lists');


  Future createList(String listName, String member) async {

    return await listCollection.doc(uid).set({
      "listName": listName,
      "member": [member],
    });
  }

  


  getAvailableLists(String email) async {
    return await listCollection.where("member", arrayContains: email).snapshots();
  }


  
  // getAvailableLists(String email) {
  //   List<String> list = [];
  //   listCollection.where("member", arrayContains: email).snapshots().listen((data) => data.docs.forEach(
  //     (doc) => list.add(doc.data()['listName'])
  //     ));
  //   return list;
  // }
}


class DatabaseServicesWOuid {

  final CollectionReference listCollection = FirebaseFirestore.instance.collection('lists');

  getPurchaseList(String listId) async {
    return await listCollection.doc(listId).collection('purchases').snapshots();
  }



  getPurchaseDoneList(String listId) async {
    return await listCollection.doc(listId).collection('purchasesDone').snapshots();
  }



  Future addMember(String name, String listId) async {
    return await listCollection.doc(listId).update({
      'member': FieldValue.arrayUnion(['$name'])
    });
  }



  Future createNewList(String listName, String member) async {

    return await listCollection.doc().set({
      "listName": listName,
      "member": [member],
    });
  }


  Future addPurchasetoList(String listId, Purchase purchase) async {
    return await listCollection.doc(listId).collection('purchases').doc().set({
      'name': purchase.name,
      'userName': purchase.userName,
      'date': purchase.date,
    });
  }


  Future addPurchaseDonetoList(String listId, Purchase purchase) async {
    return await listCollection.doc(listId).collection('purchasesDone').doc().set({
      'name': purchase.name,
      'userName': purchase.userName,
      'date': purchase.date,
    });
  }




  //delete purchase
  Future deletePurchase(listId, docId) async {
    return await listCollection.doc(listId).collection('purchases').doc(docId).delete();
  }


  Future closePurchase(String listId, Purchase purchase, String userSettingsUserName) async {
    await deletePurchase( listId, purchase.id);
    Purchase purchaseDone = Purchase();
    String _date = MyDateTime().convertString(DateTime.now());
    purchaseDone.name = purchase.name;
    purchaseDone.id = purchase.id;
    purchaseDone.date = _date;
    purchaseDone.userName = userSettingsUserName;
    return await addPurchaseDonetoList(listId, purchaseDone);
  }



  Future deletePurchaseDone(listId, docId) async {
    return await listCollection.doc(listId).collection('purchasesDone').doc(docId).delete();
  }


  Future closePurchaseDone(String listId, Purchase purchaseDone, String userSettingsUserName) async {
    await deletePurchaseDone( listId, purchaseDone.id);
    Purchase purchase = Purchase();
    String _date = MyDateTime().convertString(DateTime.now());
    purchase.name = purchaseDone.name;
    purchase.id = purchaseDone.id;
    purchase.date = _date;
    purchase.userName = userSettingsUserName;
    return await addPurchasetoList(listId, purchase);
  }

}