import 'package:flutter/material.dart';

typedef void VoidFuncWithParamater(int objectNum);

class SilentBtn extends StatelessWidget {

  final Color color;
  final VoidFuncWithParamater onPressed;
  final Widget child;
  final double width;
  final double height;
  final int objectNum;

  SilentBtn({
    @required this.onPressed,
    @required this.objectNum,
    this.color,
    this.child,
    this.width=50,
    this.height=50,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Material(
        child: InkWell(
          // onTap: () => print('OnTap'),
          onTap: () => onPressed(objectNum),
          onHover: null,
          enableFeedback: false,
          child: Container(
            width: this.width,
            height: this.height,
            decoration: new BoxDecoration(
              color: this.color,
              shape: BoxShape.circle,
              ///     image: DecorationImage(
              ///       image: ExactAssetImage('images/flowers.jpeg'),
              ///       fit: BoxFit.cover,
              ///     ),
              border: Border.all(
                color: Colors.black,
                width: 0.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 1.0, // has the effect of extending the shadow
                  offset: Offset(
                    5.0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: Center(
              child: this.child,
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}