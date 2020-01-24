import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bombTimer.dart';
import 'letterButton.dart';
import 'silentButton.dart';

void main() => runApp(CodeBreakerApp());

const clickAudioPath = "audio/click.mp3";
const victoryAudioPath = "audio/victory.mp3";
const loseAudioPath = "audio/lose.mp3";

class CodeBreakerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Breaker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CodeBreakerHome(title: 'Code Breaker'),
    );
  }
}

class CodeBreakerHome extends StatefulWidget {
  CodeBreakerHome({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _CodeBreakerHomeState createState() => _CodeBreakerHomeState();
}

class _CodeBreakerHomeState extends State<CodeBreakerHome> {
  static AudioCache player = new AudioCache();
  BombTimer bombTimer;

  Color lightIndicatorColor = Colors.red;
  bool correctSequence = true;
  int numLevelsCompleted = 0;
  int posInPattern = 0;
  int maxObjects = 5;
  int patternLength = 5;
  int _level = 0;

  List<int> pattern;
  static double _bombMaxTime = 30;
  double _timeRemaining = _bombMaxTime;
  bool timerRunning = false;

  void handleLevelSuccess() {
    posInPattern = 0;
    _generateRandomPattern();
    player.play(victoryAudioPath);
    _incrementLevel();
    setState(() {
      bombTimer.stopTimer();
      _timeRemaining = _bombMaxTime;
      timerRunning = false;
      lightIndicatorColor = Colors.yellow;
    });
  }

  void onTimerExpire() {
    timerRunning = false;
    // setState(()
    // {
    //   explosionText = "BOOM!";
    // });
  }

  void startTimer() {
    bombTimer.startTimer();
    // setState(()
    // {
    //   explosionText = "";
    // });
  }

  @override
  void initState() {
    player
        .loadAll(List.from([clickAudioPath, victoryAudioPath, loseAudioPath]));
    _generateRandomPattern();
    bombTimer = BombTimer(
      timeLeft: _timeRemaining,
      onBombTimerExpire: onTimerExpire,
      size: 120,
    );
    super.initState();
    _loadStoredData();
  }

//load the stored data from a file
  _loadStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _level = (prefs.getInt('level') ?? 0);
    });
  }

  _incrementLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _level = (prefs.getInt('level') ?? 0) + 1;
      prefs.setInt('level', _level);
    });
  }

  void _generateRandomPattern() {
    pattern = new List();
    for (int i = 0; i < patternLength; i++) {
      int rand = Random().nextInt(maxObjects);
      pattern.add(rand);
      print(rand);
    }
  }

  void _detectSequence(int object) {
    if (timerRunning == false) {
      startTimer();
      timerRunning = true;
    }

    if (pattern[posInPattern] == object) {
      posInPattern++;
      player.play(clickAudioPath);
      setState(() {
        lightIndicatorColor = Colors.green;
      });
      if (posInPattern >= patternLength) {
        handleLevelSuccess();
      }
    } else {
      posInPattern = 0;
      player.play(loseAudioPath);
      setState(() {
        lightIndicatorColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Row(
            //row 1
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: lightIndicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: <Widget>[

              //     ],
              //   ),
              // )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Level $_level",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              //row 2
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SilentBtn(
                      onPressed: (int objectNum) => _detectSequence(objectNum),
                      color: Colors.blue,
                      objectNum: 0,
                      width: MediaQuery.of(context).size.height / 16,
                      height: MediaQuery.of(context).size.height / 16,
                      child: Icon(
                        Icons.music_note,
                        color: Colors.white,
                      ),
                    ),
                    SilentBtn(
                      onPressed: (int objectNum) => _detectSequence(objectNum),
                      color: Colors.blue,
                      objectNum: 1,
                      width: MediaQuery.of(context).size.height / 16,
                      height: MediaQuery.of(context).size.height / 16,
                      child: Icon(
                        Icons.music_note,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                Container(
                  // height: 100,
                  width: MediaQuery.of(context).size.height / 30,
                ), // gap between first column and second column
                LetterButton(
                  onPressed: (int objectNum) => _detectSequence(objectNum),
                  color: Colors.yellow,
                  objectNum: 2,
                  width: MediaQuery.of(context).size.height / 8,
                  height: MediaQuery.of(context).size.height / 8,
                  letter: "A",
                ),
                LetterButton(
                  onPressed: (int objectNum) => _detectSequence(objectNum),
                  color: Colors.purple,
                  objectNum: 3,
                  width: MediaQuery.of(context).size.height / 8,
                  height: MediaQuery.of(context).size.height / 8,
                  letter: "B",
                ),
                LetterButton(
                  onPressed: (int objectNum) => _detectSequence(objectNum),
                  color: Colors.grey,
                  objectNum: 4,
                  width: MediaQuery.of(context).size.height / 8,
                  height: MediaQuery.of(context).size.height / 8,
                  letter: "C",
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    bombTimer,
                  ],
                ),
              ],
            ),
          )
        ],
        // ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Text('Replace with Light indicator'),
        //     Text('Replace with Joystick'),
        //     Text('Replace with buttons'),
        //     Text('Replace with music notes'),
        //   ],
        // ),
      ),
    );
  }
}
