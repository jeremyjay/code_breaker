import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

class BombTimer extends StatefulWidget {
  final _BombTimerState bts = _BombTimerState();
  final VoidCallback onBombTimerExpire;

  final double size;

  final double timeLeft;

  void stopTimer() {
    bts.stopTimer();
  }

  void startTimer() {
    bts.startTimer();
  }

  BombTimer({
    Key key,
    @required this.timeLeft,
    @required this.onBombTimerExpire,
    this.size = 100,
  }) : super(key: key);

  @override
  _BombTimerState createState() => bts;
}

class _BombTimerState extends State<BombTimer> {
  Timer _timer;
  double _timeLeft;
  bool timerRunning = false;
  double _size;

  void stopTimer() {
    setState( () {
      _timer.cancel();
      timerRunning = false;
      _size = widget.size;
    });
  }

  void startTimer() {
    _timeLeft = widget.timeLeft;
    timerRunning = true;
    _timer = new Timer.periodic(
      const Duration(milliseconds: 10),
      (Timer timer) => setState(
        () {
          if (_timeLeft <= 0.01) {
            _timeLeft = 0;
            timer.cancel();
            timerRunning = false;
            widget.onBombTimerExpire();
          } else {
            _timeLeft = _timeLeft - 0.01;
            int integerStart = _timeLeft.toInt();
            double fractional = _timeLeft - integerStart;
            _size = widget.size + widget.size/20*(fractional < 0.5 ? 2*fractional : 2*(1.0-fractional));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    timerRunning = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.timeLeft;
    _size = widget.size;
  }  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _timeLeft.toStringAsFixed(2),
              style: TextStyle(
                fontSize: widget.size/2.5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(
              width: _size,
              height: _size,
              child:  _timeLeft==0?
                    Image(image: AssetImage("assets/images/explosion.png")):
                    Image(image: AssetImage("assets/images/bomb.png"))
            ),
          ],
        ),
      ),
    );
  }
}
