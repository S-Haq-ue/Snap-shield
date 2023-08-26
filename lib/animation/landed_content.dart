import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_shield_alpha/utils/colors.dart';

class LandingContent extends StatelessWidget {
  const LandingContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Stay alert be safe!!",
            style: GoogleFonts.kaushanScript(
              fontSize: 36,
              color: textColor,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Everyone is sharing everything through social media ,But nobody is bothered about the data,be vigilent about what you are sharing.",
            style: TextStyle(fontSize: 24, color: Colors.black45),
          )
        ],
      ),
    );
  }
}
