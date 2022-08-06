import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:quizapp/last.dart';

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
  bool isLoaded = false;
  List<SingleQuestion> questionsList = [];

  getData() async {
    var url = Uri.parse(
        'https://quizapi.io/api/v1/questions?apiKey=$apiKey&category=${widget.category}&difficulty=${widget.difficulty}&limit=10');
    Response response = await get(url);
    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      for (var e in jsonData) {
        List<String> val = [];
        val.add(e['answers']['answer_a']);
        val.add(e['answers']['answer_b']);
        e['answers']['answer_c'] != null
            ? val.add(e['answers']['answer_c'])
            : () {};
        e['answers']['answer_d'] != null
            ? val.add(e['answers']['answer_d'])
            : () {};
        e['answers']['answer_e'] != null
            ? val.add(e['answers']['answer_e'])
            : () {};
        e['answers']['answer_f'] != null
            ? val.add(e['answers']['answer_f'])
            : () {};
        List<String> val2 = [];
        val2.add(e['correct_answers']['answer_a_correct']);
        val2.add(e['correct_answers']['answer_b_correct']);
        val2.add(e['correct_answers']['answer_c_correct']);
        val2.add(e['correct_answers']['answer_d_correct']);
        val2.add(e['correct_answers']['answer_e_correct']);
        val2.add(e['correct_answers']['answer_f_correct']);
        int index = 0;
        for (var i = 0; i < val2.length; i++) {
          if (val2[i] == 'true') {
            index = i;
            break;
          }
        }
        questionsList.add(SingleQuestion(
            text: e['question'], correctIndex: index, answers: val));
      }
      stopwatch.start();
      setState(() {
        isLoaded = true;
      });
    }
  }

  // @override
  // void initState() {
  //   getData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<QuizCubit, List<SingleQuestion>>(
        // body: BlocBuilder<LoadPageBloc, QuizStateBloc>(
        // bloc: LoadPageBloc(apiKey, widget.category, widget.difficulty),
        bloc: QuizCubit(apiKey, widget.category, widget.difficulty)..getData(apiKey, widget.category, widget.difficulty),
        builder: (context, snapshot) {
          // print(snapshot.isLoaded);
          // print(snapshot.questionsList);
          print('setstate');
          if(snapshot.isNotEmpty){
            print(snapshot.length);
          }
          questionsList = snapshot;
          return snapshot.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PageView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questionsList.length,
              itemBuilder: (context, index) {
                return singlePage(questionsList[index]);
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

  void changeChoiceValue() {
    print('old choice $choice');
    choice = !choice;
    print('new choice $choice');
  }
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
