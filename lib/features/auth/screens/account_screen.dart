// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart' show ConsumerWidget, WidgetRef;


// class AccountScreen extends ConsumerWidget {
//   const AccountScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final User user = ref.read(authProvider).currentUser!;

//     return SafeArea(
//       child: Scaffold(
//         bottomNavigationBar: const BottomOption(selectedIndex: 4),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: const ShoppingCartOption(),
//         body: SingleChildScrollView(
//           child: SizedBox(
//             width: double.maxFinite,
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 CircleAvatar(
//                   radius: 50,
//                   child: Image.asset(
//                       'assets/images/avatar/avatar_placeholder.png'),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   user.email!,
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontSize: 16),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await Utils.showMyDialog(
//                       context: context,
//                       title: 'Log out',
//                       text: 'Are you sure want to log out?',
//                       positiveText: 'Yes',
//                       negativeText: 'No',
//                       onPositivePressed: () async {
//                         Navigator.of(context).pop();
//                         await logout(ref, context).then(
//                           (value) => value == 0
//                               ? Navigator.of(context).pushNamedAndRemoveUntil(
//                                   RouteNames.intro,
//                                   (route) => false,
//                                 )
//                               : null,
//                         );
//                       },
//                       onNegativePressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     );
//                   },
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     child: Text(
//                       'Log out',
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyMedium
//                           ?.copyWith(fontSize: 18, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<int> logout(WidgetRef ref, BuildContext context) {
//     return ref.read(authProvider).logOut(context);
//   }
// }
