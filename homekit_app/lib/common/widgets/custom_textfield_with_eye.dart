import 'package:flutter/material.dart';
import 'package:homekit_app/constants/global_variables.dart';

class CustomTextFieldWithEye extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool filled;
  static Color color = GlobalVariables.fieldBackgroundColor;

  const CustomTextFieldWithEye({
    super.key,
    required this.controller,
    required this.hintText,
    required this.filled,
    color = GlobalVariables.fieldBackgroundColor,
  });

  @override
  State<CustomTextFieldWithEye> createState() => _CustomTextFieldWithEyeState();
}

class _CustomTextFieldWithEyeState extends State<CustomTextFieldWithEye> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: CustomTextFieldWithEye.color,
            border: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.black38,
            )),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.black38,
            )),
          ),
        ),
        IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ],
    );
  }
}
