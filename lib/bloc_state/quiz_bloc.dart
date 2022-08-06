import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../main.dart';
import '../quiz.dart';

class LoadPageBloc extends Bloc<QuizStateBloc, QuizStateBloc> {
  final String apiKey, category, difficulty;
  LoadPageBloc(this.apiKey, this.category, this.difficulty) : super(QuizStateBloc()){
    on<QuizStateBloc>((event, emit) async {
      print(event);
      // !event.isLoaded ? emit(await event.getData(apiKey, category, difficulty)) : emit([]);
    });
  }
}

class QuizStateBloc {
  bool isLoaded = false;
  List<SingleQuestion> questionsList = [];
  Future<List<SingleQuestion>> getData(apiKey, category, difficulty) async {
    print('lets go');
    var url = Uri.parse(
        'https://quizapi.io/api/v1/questions?apiKey=$apiKey&category=$category&difficulty=$difficulty&limit=10');
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
      isLoaded = true;
      return questionsList;
    }
    return questionsList;
  }
}

class QuizCubit extends Cubit<List<SingleQuestion>> {
  final String apiKey, category, difficulty;
  QuizCubit(this.apiKey, this.category, this.difficulty): super([]);

  void getData(apiKey, category, difficulty) async {
    List<SingleQuestion> questionsList = [];
    var url = Uri.parse(
        'https://quizapi.io/api/v1/questions?apiKey=$apiKey&category=$category&difficulty=$difficulty&limit=10');
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
      emit(questionsList);
    }
  }

}