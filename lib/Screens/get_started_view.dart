import 'dart:async';
import 'package:contact_app/Screens/home_view.dart';
import 'package:contact_app/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class GetStartedView extends StatefulWidget {
  const GetStartedView({super.key});

  @override
  State<GetStartedView> createState() => _GetStartedViewState();
}

class _GetStartedViewState extends State<GetStartedView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeView()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                    opacity: 0.35,
                    child: LottieBuilder.asset(
                      'assets/lottie/title.json',
                      height: 200,
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'K-'.toUpperCase(),
                      style: GoogleFonts.courgette(
                          fontSize: 50,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: <Color>[
                                Colors.yellow,
                                Colors.deepOrangeAccent
                              ],
                            ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))),
                    ),
                    Text(
                      'onnect'.toUpperCase(),
                      style: GoogleFonts.courgette(
                          fontSize: 30,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: <Color>[Colors.yellow, Colors.deepOrange],
                            ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Image.asset('assets/images/title.png'),
                const SizedBox(height: 16),
                Text(
                  'Discover seamless communication. \nJoin K-onnect today and \nconnect with ease.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.vidaloka(
                      fontSize: 18,
                      color: ColorConstant.textColor.withOpacity(0.40),
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
