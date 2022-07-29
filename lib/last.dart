import 'package:flutter/material.dart';

import 'main.dart';

class LastScreen extends StatefulWidget {
  const LastScreen({Key? key, required this.category, required this.difficulty, required this.count, required this.correctCount}) : super(key: key);
  final String category, difficulty;
  final int count, correctCount;

  @override
  State<LastScreen> createState() => _LastScreenState();
}

class _LastScreenState extends State<LastScreen> {

  Duration timeQuiz = Duration.zero;

  @override
  void initState() {
    timeQuiz = stopwatch.elapsed;
    stopwatch.stop();
    super.initState();
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
            Text('End Quiz'),
            Text('${widget.correctCount} / ${widget.count}'),
            Text('Category: ${widget.category}'),
            Text('Difficult: ${widget.difficulty}'),
            Text('Time: ${timeQuiz}'),
            Text('Date now: ${DateTime.now()}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){
                  save();
                }, icon: Icon(Icons.save)),
                IconButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: '',)));
                }, icon: Icon(Icons.refresh)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  save() {
    //todo
  }
}
