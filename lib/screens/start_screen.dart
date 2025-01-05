import "dart:collection";

import "package:flutter/material.dart";
import "../components/glass_container.dart";
import "../utils/constants.dart";
import "../utils/utils.dart";
import 'login_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late final LinkedHashMap<String, ButtonConfig> inputButtons;

  @override
  void initState() {
    super.initState();
    inputButtons = LinkedHashMap.from({
      "Login As Student": ButtonConfig(
        onTap: () => navigateToPage(context, const LoginScreen(userType: 0)),
        color: buttonColor,
      ),
      "Login As Teacher": ButtonConfig(
        onTap: () => navigateToPage(context, const LoginScreen(userType: 1)),
        color: buttonColor,
      ),
      "Login As Admin": ButtonConfig(
        onTap: () => navigateToPage(context, const LoginScreen(userType: 2)),
        color: buttonColor,
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: bgImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: calculatePadding(
                    constraints.maxWidth, 0.05, constraints.maxHeight, 0.05),
                child: Center(
                  child: GlassContainer(
                    blur: blur,
                    opacity: opacity,
                    color: glassColor,
                    borderRadius: borderRadius,
                    borderWidth: borderWidth,
                    child: Padding(
                      padding: calculatePadding(constraints.maxWidth, 0.05,
                          constraints.maxHeight, 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Coaching Management System",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: calculateFontSize(
                                  constraints.maxHeight, 0.045),
                              color: textColor,
                            ),
                          ),
                          Column(
                            children: buildButtons(inputButtons, constraints),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
