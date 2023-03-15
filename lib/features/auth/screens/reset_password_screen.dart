import 'package:epub_reader/features/auth/provider/auth_provider.dart';
import 'package:epub_reader/utils/constants.dart';
import 'package:epub_reader/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResetPasswordScreen extends HookConsumerWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final TextEditingController emailController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restore password',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ignore: prefer_const_constructors
                Text(
                  'Enter your email address linked with your account in order to send a restoring password email',
                  textAlign: TextAlign.justify,
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
                  height: defaultPadding * 2,
                ),
                SizedBox(
                  width: size.width,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(authProvider)
                          .sendPasswordReset(
                            toEmail: emailController.text.trim(),
                          )
                          .onError(
                            (error, stackTrace) => Utils.showMessage(
                              context: context,
                              message: error.toString(),
                            ),
                          );
                    },
                    child: const Text(
                      'Restore password',
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
    );
  }
}
