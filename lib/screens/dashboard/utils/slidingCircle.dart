import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class SlidingCircle extends StatelessWidget {
  const SlidingCircle(Color color, BoxShape shape, double width, double height,double from, double left, double right,  {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: SlideInDown(
        child: SizedBox(
          width: MediaQuery.of(context).size.width*3,
          height: MediaQuery.of(context).size.height*3,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 152, 229, 255),
            ),
          ),
        ),from:500,
      ),
      left: -MediaQuery.of(context).size.width*1,
      bottom: -MediaQuery.of(context).size.height*0.8,
    );
  }
}