import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_shield_alpha/utils/colors.dart';

class SecondaryContent extends StatelessWidget {
  const SecondaryContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to Snap Shield",
            style:  GoogleFonts.kaushanScript(
            fontSize: 36,
            color: textColor,
          ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Enable the secure mode to use secure features.",
            style: TextStyle(fontSize: 24, color: Colors.black45),
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            "secure button can be enabled at, User Profile/Side Drawer.",
            style: TextStyle(fontSize: 24, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
