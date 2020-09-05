import 'package:flutter/material.dart';
import 'package:list/services/auth.dart';
import 'package:list/shared/constants.dart';
import 'package:list/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.blueGrey[400],
      //   elevation: 0.0,
      //   title: Text('Anmelden'),
      // ),
      body: ScrollableScreen(page: _loginScreen()).build(),
    );
  }




  Widget _loginScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.tealAccent[100],
              Colors.pink[100],
            ]),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20.0),
            //Text('Platzhalter für Logo o.ä.'),
            Image.asset(
              'assets/shopping-bag-rose.png',
              height: 150,
              width: 150,
            ),
            SizedBox(height: 30.0),
            // Text('Anmelden', style: TextStyle(fontSize: 30),),
            // SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Email'),
              validator: (val) => val.isEmpty ? 'Geben Sie eine email an' : null,
              onChanged: (val) {
                setState(() => email = val.trim());
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Passwort'),
              validator: (val) =>
                  val.length < 6 ? 'Das Passwort muss mind. 6 Zeichen enthalten' : null,
              obscureText: true,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Colors.teal[200],
              child: Text(
                'Anmelden',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() => loading = true);
                  dynamic result =
                      await _auth.signInWithEmailAndPassword(email, password);
                  if (result == null) {
                    setState(() {
                      error = 'Anmeldung fehlgeschlagen';
                      loading = false;
                    });
                  }
                }
              },
            ),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
            SizedBox(height: 30.0),

            Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 2.0,
                  indent: 20.0,
                  endIndent: 20.0,
                )),
                Text('OR'),
                Expanded(
                    child: Divider(
                  thickness: 2.0,
                  indent: 20.0,
                  endIndent: 20.0,
                )),
              ],
            ),

            SizedBox(height: 12.0),
            FlatButton(
              child: Text(
                'Registrieren',
                style: TextStyle(color: Colors.black),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black, width: 1.2)),
              onPressed: () {
                widget.toggleView();
              },
            ),
          ],
        ),
      ),
    );
  }
}
