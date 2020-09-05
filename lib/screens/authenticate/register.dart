import 'package:flutter/material.dart';
import 'package:list/services/auth.dart';
import 'package:list/shared/constants.dart';
import 'package:list/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String name = '';
  String error = '';


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      // appBar: AppBar(
      //   backgroundColor: Colors.brown[400],
      //   elevation: 0.0,
      //   title: Text('Registrieren'),
      //   actions: [
      //     FlatButton.icon(
      //       icon: Icon(Icons.person),
      //       label: Text('Anmelden'),
      //       onPressed: (){
      //         widget.toggleView();
      //       },
      //     ),
      //   ],
      // ),
      body: ScrollableScreen(page: _registerScreen()).build(),
    );
  }




  Widget _registerScreen() {
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
            SizedBox(height: 40.0),
           
            Image.asset(
              'assets/shopping-bag-rose.png',
              height: 60.0,
              width: 60.0,
            ),
            SizedBox(width: 20.0),
            Text(
              'Registrieren',
              style: TextStyle(
                fontSize: 40.0,
              ),
            ),
              
            SizedBox(height: 40.0),
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
              validator: (val) => val.length < 6 ? 'Das Passwort muss mind. 6 Zeichen enthalten' : null,
              obscureText: true,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Name'),
              validator: (val) => val.isEmpty ? 'Geben Sie einen Namen an' : null,
              onChanged: (val) {
                setState(() => name = val);
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
                'Registrieren',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() => loading = true);
                  dynamic result = await _auth.registerWithEmailAndPassword(email, password, name);
                  if(result == null) {
                    setState(() {
                      error = 'Bitte geben Sie eine gültige email-adresse an';
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

            SizedBox(height: 20.0),
            Text(
              'Ich habe bereits einen Account'
            ),
            SizedBox(height: 12.0),
            FlatButton(
              child: Text(
                'Anmelden',
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
