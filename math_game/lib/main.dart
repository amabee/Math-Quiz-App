import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Quiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Random rand = Random();

  late int number1;
  late int number2;
  late int number3;
  late int number4;

  late int correctAnswer;
  late List<int> answerBox;

  late int question1;
  late int question2;

  late List<Color> boxColors;

  int score = 0;

  late String question;

  @override
  void initState() {
    super.initState();

    // Initialize boxColors with the default color
    boxColors = List.filled(4, Colors.blue.shade900);

    startGame();
  }

  void startGame() {
    int selectedQuestionIndex = rand.nextInt(4);
    setState(() {
      question1 = rand.nextInt(50) + 1;
      question2 = rand.nextInt(50) + 1;

      switch (selectedQuestionIndex) {
        case 0:
          question = "$question1 + $question2 = ";
          correctAnswer = question1 + question2;
          break;
        case 1:
          question = "$question1 - $question2 = ";
          correctAnswer = question1 - question2;
          break;
        case 2:
          question = "$question1 * $question2 = ";
          correctAnswer = question1 * question2;
          break;
        case 3:
          question = "$question1 / $question2 = ";
          correctAnswer = question1 ~/ question2;
          break;
        default:
          question = "";
          correctAnswer = 0;
      }

      print("The selected question index is: $selectedQuestionIndex");
      print("The question is: $question");
      print("The correct answer is: $correctAnswer");
    });

    generateCorrectAnswer();
  }

  void generateCorrectAnswer() {
    Set<int> correctNum = <int>{};

    correctNum.add(correctAnswer);

    for (int i = 0; i < 3; i++) {
      int wrongNumber;
      do {
        wrongNumber = rand.nextInt(99);
      } while (correctNum.contains(wrongNumber));
      correctNum.add(wrongNumber);
    }

    List<int> answerList = correctNum.toList();

    answerList.shuffle();

    answerBox = answerList;
  }

  void nextQuestion() {
    startGame();
  }

  void checkAnswer(int selectedAnswer) {
    bool isCorrect = selectedAnswer == correctAnswer;

    if (!isCorrect) {
      setState(() {
        score -= 1;
        boxColors = List.generate(
            4,
            (index) => index == answerBox.indexOf(correctAnswer)
                ? Colors.red.shade900
                : Colors.blue.shade900);
      });
      print('Incorrect!');
    } else {
      setState(() {
        score += 1;
        boxColors = List.generate(
            4,
            (index) => index == answerBox.indexOf(correctAnswer)
                ? Colors.green.shade900
                : Colors.blue.shade900);
      });
    }

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        boxColors = List.filled(4, Colors.blue.shade900);
      });
      nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[300],
      body: Column(
        children: [
          Container(
            color: Colors.deepPurple,
            height: 70,
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: Colors.yellow[300],
                          ),
                          const SizedBox(width: 5),
                          Text(
                            // SCORE
                            score.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.question_mark_outlined,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blueAccent,
              height: 100,
              width: 500,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      question,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.deepPurple[900],
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: GridView.builder(
                physics:
                    const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                itemCount: answerBox.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      checkAnswer(answerBox[index]);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: boxColors[index], // Use boxColors[index] here
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.blueAccent.shade700,
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          answerBox[index].toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
