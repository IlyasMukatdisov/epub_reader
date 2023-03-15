import 'package:epub_reader/firebase_options.dart';
import 'package:epub_reader/home_screen.dart';
import 'package:epub_reader/utils/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const SafeArea(
        child: HomeScreen(),
      ),
    );
  }
}
