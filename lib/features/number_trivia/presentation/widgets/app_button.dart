import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key,
      required this.appButtonText,
      required this.bg,
      required this.fg, this.appButtonOnPressed});
  final String appButtonText;
  final Color bg;
  final Color fg;
  final void Function()? appButtonOnPressed;
  static const TextStyle appTextSize = TextStyle(fontSize: 16.0);
  static RoundedRectangleBorder appButtonShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
  static const Size appButtonMinimunSize = Size(double.infinity, 64);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
          onPressed: appButtonOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            shape: appButtonShape,
            minimumSize: appButtonMinimunSize,
          ),
          child: Text(appButtonText, style: appTextSize)),
    );
  }
}
