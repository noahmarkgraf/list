import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //       begin: Alignment.topRight,
      //       end: Alignment.bottomLeft,
      //       colors: [
      //         Colors.tealAccent[100],
      //         Colors.pink[100],
      //       ]),
      // ),
      child: Center(
        child: SpinKitRing(
          color: Color.fromRGBO(195, 138, 158, 1),
          size: 70.0,
        ),
      ),
    );
  }
}