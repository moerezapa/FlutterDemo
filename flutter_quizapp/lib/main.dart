/**
 *  we can import this flutter library because
 *  we connected through pubspec.yaml
 */
import 'package:flutter/material.dart';

/*
   *  in main(), we need to execute some code which takes
   *  our widget and draws it to the screen
  
   *   how to run main() function:
      1. 
        void main() { runApp(MyApp()); }

      2. this way only for one expression
        void main() => runApp(MyApp());
*/

void main() => runApp(MyApp());
/*
  a widget is a object
  so to do it, we need create a class

  every widget in flutter needs to extends stateless or stateful widget

  every widget is just a dart class which
  in the end has a build() method
*/
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var questionIndex = 0;

  void answerQuestion() {
    setState(() {
     /**
      *   setState() is a function that is provided by state class which we inherit and set state takes a fucntion

      */ 
      questionIndex = questionIndex + 1;
    });
    print(questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    var questions = [
      'What\'s your favourite color?',
      'What\'s your favourite animal?'
    ];

    
    // must return a widget object
    /*
      MaterialApp is provided by material.dart
      it contains some arguments

      Scaffold has the job of creating a base page design
    */
    return MaterialApp(home: Scaffold(
      appBar: AppBar(
        title: Text('My First Flutter App'),
      ),
      body: Column(
        children: [
          Text(
            questions[questionIndex],
          ),
          RaisedButton(
            child: Text('Answer 1'), 
            onPressed: answerQuestion, // need a return value of answerQuestion() to be executed. so gausah tanda ()
          ), // onPressed() should be executed when clicked
          RaisedButton(
            child: Text('Answer 2'), 
            onPressed: () => print('Answer 2 chosen!'),
          ),
          RaisedButton(
            child: Text('Answer 3'), 
            onPressed: () {
              print('Answer 3 chosen!');
            },
          ),
        ],
      ),
    ),);
  }
}