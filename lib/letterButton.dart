import 'package:flutter/material.dart';

import 'silentButton.dart';

typedef void VoidFuncWithParamater(int objectNum);

class LetterButton extends StatelessWidget {
  final Color color;
  final VoidFuncWithParamater onPressed;
  final Widget child;
  final double width;
  final double height;
  final int objectNum;
  final String letter;

  LetterButton({
    @required this.onPressed,
    @required this.objectNum,
    this.color,
    this.child,
    this.width = 50,
    this.height = 50,
    this.letter = "",
  });

  @override
  Widget build(BuildContext context) {
    return SilentBtn(
      onPressed: onPressed,
      color: this.color,
      objectNum: this.objectNum,
      width: this.width,
      height: this.height,
      child: Stack(
        children: <Widget>[
          Text(
            this.letter,
            style: TextStyle(
              fontSize: this.width/2,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = Colors.black12,
            ),
          ),
          Text(
            this.letter,
            style: TextStyle(
              fontSize: this.width/2,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
