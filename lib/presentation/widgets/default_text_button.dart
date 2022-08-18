import 'package:flutter/material.dart';

import '../../style/colors.dart';

class DefaultTextButton extends StatelessWidget {
  DefaultTextButton({
    Key? key,
    this.fontSize,
    required this.function,
    required this.text,
  }) : super(key: key);

  Function function;
  String text;
  double? fontSize = 25;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        function();
      },
      style: TextButton.styleFrom(primary: ColorStyle.secondaryColor),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          color: ColorStyle.textTitle,
        ),
      ),
    );
  }
}
