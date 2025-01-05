import "dart:collection";

import "package:flutter/material.dart";
import "../components/glass_container.dart";
import "../utils/constants.dart";
import "../utils/utils.dart";

class LoginScreen extends StatefulWidget {
  final int userType;

  const LoginScreen({required this.userType, super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  late int _userType;
  late final LinkedHashMap<String, ButtonConfig> inputButtons;

  @override
  void initState() {
    super.initState();
    _userType = widget.userType;
    inputButtons = LinkedHashMap.from({
      "Login": ButtonConfig(
        onTap: () =>
            login(context, _idController, _passwordController, _userType),
        color: buttonColor,
      ),
      "Back": ButtonConfig(
        onTap: () => Navigator.pop(context),
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
                            getLoginTitle(_userType),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: calculateFontSize(
                                  constraints.maxHeight, 0.045),
                              color: textColor,
                            ),
                          ),
                          Column(
                            children: [
                              TextField(
                                controller: _idController,
                                decoration: InputDecoration(
                                  labelText: "ID",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(borderRadius),
                                  ),
                                  filled: true,
                                  fillColor: glassColor,
                                ),
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.01,
                              ),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(borderRadius),
                                  ),
                                  filled: true,
                                  fillColor: glassColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
