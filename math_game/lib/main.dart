import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MyHomePage({super.key});

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

  late int question1 = Random().nextInt(10);
  late int question2 = Random().nextInt(10);

  int score = 0;

  late List<String> randomizeQuestions;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    question1 = rand.nextInt(10);
    question2 = rand.nextInt(10);
    randomizeQuestions = [
      "$question1 + $question2 = ",
      "$question1 - $question2 = ",
      "$question1 * $question2 = ",
      "$question1 / $question2 = ",
    ];

    do {
      question1 = rand.nextInt(10);
      question2 = rand.nextInt(10);
    } while (randomizeQuestions[3] == "$question1 / $question2 = ");

    switch (rand.nextInt(4)) {
      case 0:
        correctAnswer = question1 + question2;
        break;
      case 1:
        correctAnswer = question1 - question2;
        break;
      case 2:
        correctAnswer = question1 * question2;
        break;
      case 3:
        correctAnswer = (question1 / question2).floor();
        break;
      default:
        correctAnswer = 0;
    }

    answerBox = [];
    generateUniqueNumbers();
    answerBox[rand.nextInt(4)] = correctAnswer;
  }

  void generateUniqueNumbers() {
    Set<int> uniqueNumbers = <int>{};
    while (uniqueNumbers.length < 4) {
      int newNumber = rand.nextInt(10);
      uniqueNumbers.add(newNumber);
    }
    answerBox = uniqueNumbers.toList()..shuffle();
  }

  void nextQuestion() {
    startGame();
  }

  void checkAnswer(int selectedAnswer) {
    if (selectedAnswer == correctAnswer) {
      print('Correct!');
      setState(() {
        score += 1;
      });
      nextQuestion();
    } else {
      print('Incorrect!');
    }
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
                      randomizeQuestions[
                          rand.nextInt(randomizeQuestions.length)],
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
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.blue.shade900,
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          answerBox[index].toString(),
                          style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
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
