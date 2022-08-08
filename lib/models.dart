import 'package:flutter/cupertino.dart';

class MyState {
  MyState(this.text, this.children);
  String text;
  List<Widget> children;
}

class SingleQuestion {
  SingleQuestion({
    required this.text,
    required this.correctIndex,
    required this.answers,
  });

  final String text;
  final int correctIndex;
  final List<String> answers;
}

class Answer {
  Answer({
    required this.text,
    required this.isTrue,
  });

  bool choice = false;
  final String text;
  final bool isTrue;
}