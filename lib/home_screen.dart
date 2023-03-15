import 'package:epub_reader/features/auth/provider/auth_provider.dart';
import 'package:epub_reader/features/auth/screens/verify_email.dart';
import 'package:epub_reader/features/auth/screens/welcome_screen.dart';
import 'package:epub_reader/features/book/screens/all_books.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentUser = ref.watch(authProvider).currentUser;

    if (currentUser == null) {
      return const WelcomeScreen();
    }

    if (currentUser.emailVerified) {
      return const AllBooksScreen();
    }
    return const VerifyEmailScreen();
  }
}
