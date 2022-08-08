import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:quizapp/single_page.dart';
import '/last.dart';

import 'bloc_state/quiz_bloc.dart';
import 'main.dart';
import 'models.dart';

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
        bloc: QuizCubit(apiKey, widget.category, widget.difficulty)
          ..getData(apiKey, widget.category, widget.difficulty),
        builder: (context, snapshot) {
          questionsList = snapshot;
          return snapshot.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PageView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questionsList.length,
              itemBuilder: (context, index) {
                return SinglePage(questionsList: questionsList,
                  difficulty: widget.difficulty,
                  category: widget.category,);
              });
        },
      ),
    );
  }
}
