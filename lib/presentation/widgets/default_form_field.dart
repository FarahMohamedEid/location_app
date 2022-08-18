import 'package:flutter/material.dart';

import '../../style/colors.dart';

class DefaultFormField extends StatelessWidget {
  const DefaultFormField({
    Key? key,
    this.controller,
    this.height = 60,
    this.hintMaxLines = 1,
    this.hintText = " ",
    this.autoFocus = true,
    required this.inputType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.expands = false,
    this.onSubmit,
    this.onTap,
    this.maxLines = 1,
    this.suffixIcon,
    this.suffixPressed,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? hintText;
  final bool autoFocus;
  final TextInputType inputType;
  final bool obscureText;
  final Function? validator;
  final Function? onChanged;
  final ValueChanged<String>? onSubmit;
  final Function? onTap;
  final Function? suffixPressed;
  final double height;
  final int hintMaxLines;
  final bool expands;
  final IconData? suffixIcon;
  final dynamic maxLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        cursorColor: ColorStyle.textTitle,
        validator: (value) {
          if (validator != null) {
            return validator!(value);
          }
          return null;
        },
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!(value);
          }
        },
        onFieldSubmitted: onSubmit,
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        keyboardType: inputType,
        maxLines: maxLines,
        expands: expands,
        obscureText: obscureText,
        controller: controller,
        style: const TextStyle(
          fontSize: 16.0,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16.0,
            color: ColorStyle.secondaryColor,
          ),
          hintMaxLines: hintMaxLines,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  onPressed: () {
                    suffixPressed!();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    suffixIcon,
                    color: ColorStyle.secondaryColor,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: ColorStyle.secondaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: ColorStyle.secondaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: ColorStyle.textTitle,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: ColorStyle.mainColor,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        ),
      ),
    );
  }
}
