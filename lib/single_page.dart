import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/bloc_state/single_page_bloc.dart';

import 'models.dart';

class SinglePage extends StatelessWidget {
  const SinglePage({Key? key, required this.questionsList, required this.category, required this.difficulty}) : super(key: key);
  final List<SingleQuestion> questionsList;
  final String category, difficulty;

  @override
  Widget build(BuildContext context) {
    MyState myState;
    return BlocBuilder<SinglePageBloc, MyState>(
      bloc: SinglePageBloc(questionsList, context, category, difficulty),
      builder: (BuildContext context, snapshot) {
        myState = snapshot;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(myState.text),
            ),
            Column(
              children: myState.children,
            ),
          ],
        );
      },
    );
  }
}
