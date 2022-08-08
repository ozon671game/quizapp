import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:quizapp/single_page.dart';
import '/last.dart';

import 'bloc_state/quiz_bloc.dart';
import 'main.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key, required this.category, required this.difficulty})
      : super(key: key);
  final String category, difficulty;

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int correctCount = 0;
  int pageIndex = 0;
  final PageController controller = PageController();
  static const String apiKey = 'j24WhINsXuMG7PszLmbkLHqRiXRoFnjRZrHxkwDa';
  List<SingleQuestion> questionsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<QuizCubit, List<SingleQuestion>>(
        bloc: QuizCubit(apiKey, widget.category, widget.difficulty)..getData(apiKey, widget.category, widget.difficulty),
        builder: (context, snapshot) {
          questionsList = snapshot;
          return snapshot.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PageView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questionsList.length,
              itemBuilder: (context, index) {
                return SinglePage(questionsList: questionsList);
              });
        },
      ),
    );
  }

  Widget singlePage(SingleQuestion question) {
    List<Answer> answersList = List.generate(question.answers.length, (index) {
      return Answer(
          text: question.answers[index],
          isTrue: index == question.correctIndex ? true : false);
    });
    List<Widget> childrenForColumn = List.generate(answersList.length, (index) {
      return ListTile(
        onTap: () {
          if (answersList[index].isTrue) {
            correctCount++;
          }
          goNext();
        },
        title: Text(answersList[index].text),
      );
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(question.text),
        ),
        Column(
          children: childrenForColumn,
        ),
      ],
    );
  }

  goNext() {
    if (pageIndex >= questionsList.length -1) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LastScreen(
                category: widget.category,
                difficulty: widget.difficulty,
                correctCount: correctCount,
                count: questionsList.length,
              )));
    }
    pageIndex++;
    controller.jumpToPage(pageIndex);
  }
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
