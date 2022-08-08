import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../last.dart';
import '../models.dart';

class SinglePageBloc extends Cubit<MyState>{
  final List<SingleQuestion> questionsList;
  final BuildContext _context;
  final String _category, _difficulty;
  int correctCount = 0;
  int currentIndex = 0;
  SinglePageBloc(this.questionsList, this._context, this._category, this._difficulty) : super(MyState('', [])){
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
          _onTapChildForColumn(answersList[index].isTrue);
        },
        title: Text(answersList[index].text),
      );
    });
    return MyState(question.text, childrenForColumn);
  }

  _onTapChildForColumn(bool isTrue) {
    if(isTrue) {
      correctCount++;
    }
    currentIndex++;
    _reBuildPage();
  }

  _reBuildPage() {
    if(currentIndex >= questionsList.length){
      _goNextScreen();
    }
    emit(initWidgets(questionsList[currentIndex]));
  }

  _goNextScreen() {
    Navigator.pushReplacement(
        _context,
        MaterialPageRoute(
            builder: (context) => LastScreen(
              category: _category,
              difficulty: _difficulty,
              correctCount: correctCount,
              count: questionsList.length,
            )));
  }
}