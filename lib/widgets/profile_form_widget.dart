// import 'package:flutter/material.dart';
// import 'package:snap_shield_alpha/utils/colors.dart';

// class ProfileFormWidget extends StatelessWidget {
//   final TextEditingController? controller;
//   final String? title;
//   const ProfileFormWidget({super.key, this.controller, this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "$title",
//           style: const TextStyle(color: primaryColor, fontSize: 16),
//         ),
//         const SizedBox(height: 10,),
//         TextFormField(
//           controller: controller,
//           style: const TextStyle(
//             color: primaryColor,
//           ),
//           decoration: const InputDecoration(
//             border: InputBorder.none,
//             labelStyle: TextStyle(color: primaryColor),
//           ),
//         ),
//         Container(
//           width: double.infinity,
//           height: 1,
//           color: secondaryColor,
//         )
//       ],
//     );
//   }
// }
