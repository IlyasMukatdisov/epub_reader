import 'package:epub_reader/features/auth/screens/login_screen.dart';
import 'package:epub_reader/features/auth/screens/register_screen.dart';
import 'package:epub_reader/features/auth/screens/reset_password_screen.dart';
import 'package:epub_reader/features/auth/screens/verify_email.dart';
import 'package:epub_reader/features/book/screens/all_books.dart';
import 'package:epub_reader/features/book/screens/book_screen.dart';
import 'package:epub_reader/utils/route_names.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.login:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case RouteNames.register:
      return MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      );
    case RouteNames.resetPassword:
      return MaterialPageRoute(
        builder: (context) => const ResetPasswordScreen(),
      );
    case RouteNames.verifyEmail:
      return MaterialPageRoute(
        builder: (context) => const VerifyEmailScreen(),
      );
    case RouteNames.bookDetails:
      return MaterialPageRoute(
        builder: (context) => const BookScreen(),
      );
    case RouteNames.allBooks:
      return MaterialPageRoute(
        builder: (context) => const AllBooksScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text(
              'No route defined for ${settings.name}',
            ),
          ),
        ),
      );
  }
}
