import 'package:epub_reader/utils/route_names.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    debugPrint(size.height.toString());
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: size.height < 500
            ? WelcomeScrollable(size: size)
            : Welcome(size: size),
      ),
    );
  }
}

class Welcome extends StatelessWidget {
  const Welcome({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset(
          'assets/images/logo.png',
          width: size.width > 200 ? 200 : size.width,
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.05),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.login,
                (route) => false,
              );
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              width: size.width / 2,
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WelcomeScrollable extends StatelessWidget {
  const WelcomeScrollable({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            'assets/images/logo.png',
            width: size.width / 2,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.05),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.login,
                  (route) => false,
                );
              },
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                width: size.width / 2,
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
