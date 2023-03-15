import 'package:epub_reader/features/auth/provider/auth_provider.dart';
import 'package:epub_reader/utils/constants.dart';
import 'package:epub_reader/utils/route_names.dart';
import 'package:epub_reader/utils/utils.dart';
import 'package:epub_reader/utils/widgets/loading_overlay.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return LoadingOverlay(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: size.width > 200 ? 200 : size.width,
                  ),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
                  TextFormField(
                    cursorColor: primaryColor,
                    autocorrect: false,
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  TextFormField(
                    cursorColor: primaryColor,
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.password),
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
                  SizedBox(
                    width: size.width,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (emailController.text.isEmpty &&
                            passwordController.text.isEmpty) {
                          Utils.showMessage(
                              context: context,
                              message: "Please enter email and password");
                          return;
                        }
                        ref.read(loadingOverlayProvider.notifier).state =
                            true;
                        ref
                            .read(authProvider)
                            .signInWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            )
                            .onError(
                          (error, stackTrace) {
                            Utils.showMessage(
                              context: context,
                              message: error.toString(),
                            );
                          },
                        ).then(
                          (value) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              RouteNames.allBooks,
                              (route) => false,
                            );
                          },
                        ).whenComplete(
                          () => ref
                              .read(loadingOverlayProvider.notifier)
                              .state = false,
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  SizedBox(
                    width: size.width,
                    height: 45,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.resetPassword,
                        );
                      },
                      child: const Text(
                        'Forget password? Restore it here',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width,
                    height: 45,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.register);
                      },
                      child: const Text(
                        "Don't have an account? Create it here",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
