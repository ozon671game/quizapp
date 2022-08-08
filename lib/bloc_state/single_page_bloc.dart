import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../quiz.dart';

class SinglePageBloc extends Cubit<MyState>{
  final List<SingleQuestion> questionsList;
  int correctCount = 0;
  int currentIndex = 0;
  SinglePageBloc(this.questionsList) : super(MyState('', [])){
    emit(initWidgets(questionsList.first));
  }

  MyState initWidgets(SingleQuestion question) {
    List<Answer> answersList = List.generate(question.answers.length, (index) {
      return Answer(
          text: question.answers[index],
          isTrue: index == question.correctIndex ? true : false);
    });
    var childrenForColumn = List.generate(answersList.length, (index) {
      return ListTile(
        onTap: (){
          onTapChildForColumn(answersList[index].isTrue);
        },
        title: Text(answersList[index].text),
      );
    });
    return MyState(question.text, childrenForColumn);
  }

  onTapChildForColumn(bool isTrue) {
    if(isTrue) {
      correctCount++;
    }
    currentIndex++;
    reBuildPage();
  }

  reBuildPage() {
    if(currentIndex >= questionsList.length){
      //todo
    }
    emit(initWidgets(questionsList[currentIndex]));
  }
}

class MyState {
  MyState(this.text, this.children);
  String text;
  List<Widget> children;
}