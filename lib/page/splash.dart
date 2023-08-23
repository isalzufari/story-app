import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Storygram",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
