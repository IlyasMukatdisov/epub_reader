import 'package:epub_reader/features/auth/provider/auth_provider.dart';
import 'package:epub_reader/features/auth/screens/verify_email.dart';
import 'package:epub_reader/utils/constants.dart';
import 'package:epub_reader/utils/route_names.dart';
import 'package:epub_reader/utils/utils.dart';
import 'package:epub_reader/utils/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final TextEditingController emailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final TextEditingController confirmPasswordController =
        useTextEditingController();

    return LoadingOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register',
          ),
        ),
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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder().copyWith(
                          borderSide: const BorderSide(color: primaryColor)),
                      prefixIcon: const Icon(Icons.email),
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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder().copyWith(
                          borderSide: const BorderSide(color: primaryColor)),
                      prefixIcon: const Icon(Icons.password),
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  TextFormField(
                    cursorColor: primaryColor,
                    controller: confirmPasswordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder().copyWith(
                          borderSide: const BorderSide(color: primaryColor)),
                      prefixIcon: const Icon(Icons.password),
                      labelText: 'Confirm Password',
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
                  SizedBox(
                    width: size.width,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (passwordController.text.trim() ==
                            confirmPasswordController.text.trim()) {
                          ref.read(loadingOverlayProvider.notifier).state =
                              true;
                          await ref
                              .read(authProvider)
                              .createUser(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              )
                              .onError(
                                (error, stackTrace) => Utils.showMessage(
                                  context: context,
                                  message: error.toString(),
                                ),
                              )
                              .then(
                            (value) async {
                              await ref
                                  .read(authProvider)
                                  .sendEmailVerification()
                                  .then(
                                    (value) => Navigator.of(context)
                                        .pushNamed(RouteNames.verifyEmail),
                                  );
                            },
                          );
                          ref.read(loadingOverlayProvider.notifier).state =
                              false;
                        } else {
                          Utils.showMessage(
                              context: context,
                              message: "Passwords don't match");
                        }
                      },
                      child: const Text(
                        'Register',
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
