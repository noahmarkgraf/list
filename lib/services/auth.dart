import 'package:firebase_auth/firebase_auth.dart';
import 'package:list/models/user.dart';
import 'package:list/models/user_settings.dart';
import 'package:list/services/database.dart';



class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  //current User 
  MyUser getCurrentUser() {
    User u = _auth.currentUser;
    return _userFromFirebase(u);
  }


  //create user obj based on FirebaseUser
  MyUser _userFromFirebase(User user) {
    return user != null ? createUser(user) : null;
  }

  MyUser createUser(User user) {
    MyUser m = MyUser(uid: user.uid);
    m.tryLogin = true;
    return m;
  }


  //auth change user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map((User user) => _userFromFirebase(user));
    //return _auth.authStateChanges().map(_userFromFirebase);
  }


  //sign in anon
  Future signInAnon() async {
    try {
      //AuthResult == UnserCredential
      UserCredential result = await _auth.signInAnonymously();
      //UserCredential result = await _auth.createUserWithEmailAndPassword(email: null, password: null);
      //FirebaseUser == User
      User user = result.user;
      return _userFromFirebase(user);
    } catch(e) {
      print('Fehlermerldung - ${e.toString()}');
      return null;
    }
  }

  
  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebase(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  //register with email and password
  Future registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      //create a new document with user uid
      UserSettings userSettings = UserSettings(name: name, uid: user.uid, email: email);
      await DatabaseService(uid: user.uid).updateUserSettings(userSettings);
      await DatabaseService(uid: user.uid).createList('Zuhause', userSettings.email);
      return _userFromFirebase(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}