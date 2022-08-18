import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.onPressed,
    required this.color,
    required this.text,
    this.borderColor,
    this.textColor,
    this.loading = false,
    this.icon,
  }) : super(key: key);
  final Function onPressed;
  final Color color;
  final Color? borderColor, textColor;
  final String text;
  final bool loading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (!loading) onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: loading
                ? SizedBox(
                    height: 40,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: textColor ?? Colors.white,
                      strokeWidth: 3,
                    ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(text),
                      if (icon != null)
                        const SizedBox(
                          width: 10,
                        ),
                      if (icon != null) icon!
                    ],
                  ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: borderColor ?? color),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
