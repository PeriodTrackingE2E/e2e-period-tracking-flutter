import 'dart:math';

import 'package:e2e_period_tracking/screens/profile_screen.dart';
import 'package:e2e_period_tracking/screens/setup_screen.dart';
import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:e2e_period_tracking/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      width > 500 ? kSizeH16 : kSizeH64,
                      const CustomText(
                        text: "E2E",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Period Tracker",
                        style: GoogleFonts.inter().copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      kSizeH32,
                      SizedBox.square(
                        dimension: min(min(width * 0.6, height * 0.6), 500),
                        child: SvgPicture.asset(
                          "e2e_welcome.svg",
                        ),
                      ),
                      kSizeH16,
                      Text(
                        "Keep your data safe and secure\nwith end-to-end encryption.",
                        style: GoogleFonts.inter().copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      kSizeH32,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => prefs.getBool(Preferences
                                          .hasAlreadyPasswordSetted) ==
                                      true
                                  ? ProfileScreen()
                                  : SetupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "START TRACKING NOW",
                          style: GoogleFonts.inter().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 0,
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "How it works?",
                        style: GoogleFonts.inter().copyWith(
                          decoration: TextDecoration.underline,
                          color: Colors.black87,
                        ),
                      ),
                      kSizeW16,
                      const Icon(
                        Icons.help,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  onPressed: () => print("how it works"),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
