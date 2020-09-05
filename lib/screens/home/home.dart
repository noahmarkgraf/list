import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list/models/purchase.dart';
import 'package:list/models/purchase_done.dart';
import 'package:list/models/user.dart';
import 'package:list/models/user_settings.dart';
import 'package:list/screens/home/purchase_list.dart';
import 'package:list/screens/home/purchase_list_done.dart';
import 'package:list/screens/home/settings.dart';
import 'package:list/services/auth.dart';
import 'package:list/services/database.dart';
import 'package:list/shared/loading.dart';





class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();


  Future<UserSettings> load() async {
    
    final MyUser myUser = _auth.getCurrentUser();
    // UserSettings userSettings = await DatabaseService(uid: myUser.uid).readUserSettings();
    // return userSettings;

    return userSettings = await DatabaseService(uid: myUser.uid).readUserSettings();

  }

  UserSettings userSettings;



  @override
  Widget build(BuildContext context) {

    return Provider<UserSettings>(
      create: (_) => UserSettings(),
      child: StreamProvider<List<PurchaseDone>>.value(
        value: DatabaseService().purchasesDone,
        child: StreamProvider<List<Purchase>>.value(
          value: DatabaseService().purchases,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.brown[50],
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.tealAccent[100], Colors.pink[100]]),
                  ),
                ),
                title: Text('Einkaufsliste', style: TextStyle(color: Colors.black),),
                backgroundColor: Colors.brown[400],
                elevation: 0.0,
                actions: <Widget>[
                  RotatedBox(
                    quarterTurns: 2,
                    child: IconButton(
                      color: Colors.black,
                      iconSize: 32.0,
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                      tooltip: 'abmelden',
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      tooltip: 'Einstellungen',
                      color: Colors.black,
                      iconSize: 32.0,
                      icon: Icon(Icons.settings),
                      onPressed: () async {
                        UserSettings ab = UserSettings();
                        ab.name = userSettings.name;
                        ab.uid = userSettings.uid;
                        final UserSettings result = await Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SettingsScreen(userSettings: ab)
                        ));
                        if (result != null) 
                          userSettings.name = result.name;
                      },
                    ),
                  ),
                ],
                bottom: TabBar(
                  labelPadding: EdgeInsets.only(bottom: 12),
                  tabs: [
                    Text('zu erledigen', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                    Text('erledigt', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                  ]),
              ),
              body: _loadTabBar(),
            ),
          ),
        ),
      ),
    );
  }


  Widget _loadTabBar() {
    return FutureBuilder<UserSettings>(
      future: load(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text('Fehler'),
          );
        }

        // Once complete, show your application
        if (snapshot.hasData) {
          userSettings = Provider.of<UserSettings>(context);
          userSettings.name = snapshot.data.name;
          userSettings.uid = snapshot.data.uid;  
          return TabBarView(children: [
            PurchaseList(),
            PurchaseListDone(),
          ],);   
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}