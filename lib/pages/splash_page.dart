import 'package:flutter/material.dart';
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body:  Center(
        child:Image.asset('lib/assets/images/logo.png')
      ),
    );
  }
}
