import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const CustomButton({required this.onTap, required this.text});


  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      child: RaisedButton(
          onPressed: onTap,
      child: Text(text,
      style: TextStyle(fontSize: 15),
      ),
      ),
    );
  }
}
