import 'package:calculator/button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var question = '';
  var answer = '';

  final List<String> buttons = [
    'AC',
    '( )',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'DEL',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 38,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      question,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      answer,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: GridView.builder(
                itemCount: buttons.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {

                  // Clear Button
                  if (index == 0) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          question = '';
                          answer = '';
                        });
                      },
                      color: Colors.green[200],
                      textColor: Colors.black,
                      buttonText: buttons[index],
                    );

                    // Delete Button
                  } else if (index == (buttons.length - 2)) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          if (question.isEmpty) {
                            question = '';
                          } else {
                            question =
                                question.substring(0, question.length - 1);
                          }
                        });
                      },
                      color: Colors.redAccent[200],
                      textColor: Colors.black,
                      buttonText: buttons[index],
                    );
                  }

                  // Equal Button
                  else if (index == (buttons.length - 1)) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          equalPressed();
                        });
                      },
                      color: Colors.redAccent[200],
                      textColor: Colors.black,
                      buttonText: buttons[index],
                    );
                  }

                  // Other Buttons
                  else {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          question += buttons[index];
                        });
                      },
                      color: isOperator(buttons[index])
                          ? Colors.lightBlueAccent[100]
                          : Colors.grey[100],
                      textColor: Colors.black,
                      buttonText: buttons[index],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '%' ||
        x == '( )' ||
        x == '/' ||
        x == 'x' ||
        x == '-' ||
        x == '+' ||
        x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalQuestion = question;
    finalQuestion = finalQuestion.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    answer = eval.toString();
  }
}
