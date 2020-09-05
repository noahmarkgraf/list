import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pinkAccent, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(5.0))),
);




class ScrollableScreen {
  Widget page;

  ScrollableScreen({this.page});

  Widget build() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: page));
    });
  }
}
