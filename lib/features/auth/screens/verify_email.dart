import 'package:epub_reader/features/auth/provider/auth_provider.dart';
import 'package:epub_reader/utils/constants.dart';
import 'package:epub_reader/utils/route_names.dart';
import 'package:epub_reader/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerifyEmailScreen extends ConsumerWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'We have sent you an email verification to your account. Please open it and follow the link in email in order to activate your account\n \n'
                  "If you didn't receive an email please check your spam folder and then if you can't find it please tap the button below",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(authProvider)
                          .sendEmailVerification()
                          .onError(
                            (error, stackTrace) => Utils.showMessage(
                              context: context,
                              message: error.toString(),
                            ),
                          );
                    },
                    child: const Text(
                      'Send again',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RouteNames.login);
                    },
                    child: const Text(
                      'Already verified? Log in here',
                      style: TextStyle(fontSize: 16),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
