import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list/models/user.dart';
import 'package:list/screens/authenticate/authenticate.dart';
import 'package:list/screens/home/home.dart';
import 'package:list/shared/loading.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    if (user != null) {
      if (user.tryLogin == false) {
        return Loading();
      }
    }

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
