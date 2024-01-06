import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
   const AppTextField({super.key, required this.appInputController, this.appTextFieldOnChanged, this.appTextFieldOnSubmitted});

  final TextEditingController appInputController;
  final void Function(String)? appTextFieldOnChanged;
  final void Function(String)? appTextFieldOnSubmitted;
  static const TextStyle appTextFieldTextSize = TextStyle(fontSize: 16);
  static const OutlineInputBorder appOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: appTextFieldOnChanged,
      onSubmitted: appTextFieldOnSubmitted,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          hintText: 'Input a number', border: appOutlineInputBorder),
      style: appTextFieldTextSize,
      textAlign: TextAlign.left,
    );
  }
}
