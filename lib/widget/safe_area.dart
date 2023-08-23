import 'package:flutter/material.dart';

class SafeAreaScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? fab;

  const SafeAreaScaffold(
      {super.key, required this.body, this.appBar, this.fab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: fab,
      body: SafeArea(
        child: SingleChildScrollView(
          child: body,
        ),
      ),
    );
  }
}
