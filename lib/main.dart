import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'quiz.dart';

final stopwatch = Stopwatch();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  BlocOverrides.runZoned(
        () => runApp(const MyApp()),
    blocObserver: SimpleBlocObserver(),
  );
}

class SimpleBlocObserver extends BlocObserver {

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoaded = false;
  int categoryIndex = 0;
  int difficultyIndex = 0;

  static const List<String> categories = [
    'linux',
    'bash',
    'uncategorized',
    'docker',
    'sql',
    'cms',
    'code',
    'devops',
  ];

  static const List<String> difficulties = [
    'Easy',
    'Medium',
    'Hard',
  ];

  void showCategoryDialog() {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: CupertinoPicker(
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              // This is called when selected item is changed.
              onSelectedItemChanged: (int index) {
                setState(() {
                  categoryIndex = index;
                });
              },
              itemExtent: 25,
              children:
              List<Widget>.generate(categories.length, (int index) {
                return Center(
                  child: Text(
                    categories[index],
                  ),
                );
              }),
            ),
          ),
        ));
  }

  void showDifficultyDialog() {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: CupertinoPicker(
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              // This is called when selected item is changed.
              onSelectedItemChanged: (int index) {
                setState(() {
                  difficultyIndex = index;
                });
              },
              itemExtent: 25,
              children:
              List<Widget>.generate(difficulties.length, (int index) {
                return Center(
                  child: Text(
                    difficulties[index],
                  ),
                );
              }),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('Quiz App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Select category: ',
                    ),
                    InkWell(
                      onTap: () {
                        showCategoryDialog();
                      },
                      child: Text(
                        categories[categoryIndex],
                        style: const TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Select difficulty: ',
                    ),
                    InkWell(
                      onTap: () {
                        showDifficultyDialog();
                      },
                      child: Text(
                        difficulties[difficultyIndex],
                        style: const TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Quiz(
                            difficulty: difficulties[difficultyIndex],
                            category: categories[categoryIndex],
                          )));
                },
                child: Text('Lets Go'))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
