import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:quizapp/single_page.dart';
import '/last.dart';

import 'bloc_state/quiz_bloc.dart';
import 'main.dart';
import 'models.dart';

class Quiz extends StatelessWidget {
  const Quiz({Key? key, required this.category, required this.difficulty})
      : super(key: key);
  final String category, difficulty;
  static const String apiKey = 'j24WhINsXuMG7PszLmbkLHqRiXRoFnjRZrHxkwDa';

  @override
  Widget build(BuildContext context) {
    List<SingleQuestion> questionsList;
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<QuizCubit, List<SingleQuestion>>(
        bloc: QuizCubit(apiKey, category, difficulty)
          ..getData(),
        builder: (context, snapshot) {
          questionsList = snapshot;
          return snapshot.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SinglePage(questionsList: questionsList,
            difficulty: difficulty,
            category: category,);
        },
      ),
    );
  }
}
