import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;

  const CustomErrorWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message,
          style: const TextStyle(
              fontSize: 12,
              color: Colors.white
          ),
        ),
      ),
    );
  }
}