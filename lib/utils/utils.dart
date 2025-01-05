import "dart:async";
import "dart:collection";
import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:coaching_management_system/components/custom_button.dart";
import "../screens/dashboard_screen.dart";
import "constants.dart";

double calculateFontSize(double screenHeight, double ratio) {
  return screenHeight * ratio;
}

EdgeInsets calculatePadding(double screenWidth, double paddingHorizontal,
    double screenHeight, double paddingVertical) {
  return EdgeInsets.symmetric(
    horizontal: screenWidth * paddingHorizontal,
    vertical: screenHeight * paddingVertical,
  );
}

Future<void> login(BuildContext context, TextEditingController idController,
    TextEditingController passwordController, int userType) async {
  var userId = idController.text.trim();
  final userPassword = passwordController.text.trim();

  if (userId.isEmpty || userPassword.isEmpty) {
    showErrorDialog(context, "Please fill in both fields.");
    return;
  }

  if (userType == 0) {
    userId = "S-$userId";
  } else if (userType == 1) {
    userId = "T-$userId";
  } else {
    userId = "A-$userId";
  }

  try {
    final response = await Supabase.instance.client
        .from("Users")
        .select()
        .eq("user_id", userId)
        .eq("user_password", userPassword);

    if (response.isEmpty) {
      showErrorDialog(context, "Invalid ID or password.");
    } else {
      navigateToPage(
          context, DashboardScreen(userType: userType, userId: userId));
    }
  } catch (e) {
    showErrorDialog(context, "An error occurred. Please try again.");
  }
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Login Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

String getLoginTitle(int userType) {
  switch (userType) {
    case 0:
      return "Login As Student";
    case 1:
      return "Login As Teacher";
    default:
      return "Login As Admin";
  }
}

Widget buildButton(
    String text, VoidCallback onTap, Color color, BoxConstraints constraints) {
  return CustomButton(
    text: text,
    padding: calculatePadding(
        constraints.maxWidth, 0.01, constraints.maxHeight, 0.01),
    borderRadius: borderRadius,
    color: color,
    fontSize: calculateFontSize(constraints.maxHeight, 0.03),
    fontFamily: fontFamily,
    textColor: textColor,
    onTap: onTap,
  );
}

List<Widget> buildButtons(LinkedHashMap<String, ButtonConfig> inputButtons,
    BoxConstraints constraints) {
  List<Widget> buttons = [];
  int buttonCount = inputButtons.length;
  int currentIndex = 0;

  inputButtons.forEach((text, inputs) {
    buttons.add(buildButton(text, inputs.onTap, inputs.color, constraints));
    currentIndex++;

    if (currentIndex < buttonCount) {
      buttons.add(SizedBox(
        height: constraints.maxHeight * 0.01,
      ));
    }
  });

  return buttons;
}

void navigateToPage(BuildContext context, Widget destination,
    {Offset? startOffset}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          begin: startOffset ?? const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}

String getDashboardTitle(int userType) {
  switch (userType) {
    case 0:
      return "Student Dashboard";
    case 1:
      return "Teacher Dashboard";
    default:
      return "Admin Dashboard";
  }
}

class ButtonConfig {
  final VoidCallback onTap;
  final Color color;

  const ButtonConfig({
    required this.onTap,
    required this.color,
  });
}

Widget buildDataRow(
    String key, dynamic value, Color color, BoxConstraints constraints) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    padding: calculatePadding(
        constraints.maxWidth, 0.02, constraints.maxHeight, 0.02),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            key,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: calculateFontSize(constraints.maxHeight, 0.02),
              color: textColor,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value is String ? value : value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: calculateFontSize(constraints.maxHeight, 0.02),
              color: textColor,
            ),
          ),
        ),
      ],
    ),
  );
}

List<Widget> buildDataRows(
    LinkedHashMap<String, dynamic> inputDataRows, BoxConstraints constraints) {
  List<Widget> dataRows = [];
  int dataRowCount = inputDataRows.length;
  int currentIndex = 0;

  inputDataRows.forEach((key, value) {
    dataRows.add(buildDataRow(key, value, buttonColor, constraints));
    currentIndex++;

    if (currentIndex < dataRowCount) {
      dataRows.add(SizedBox(
        height: constraints.maxHeight * 0.01,
      ));
    }
  });

  return dataRows;
}

Widget updateDataRow(String key, String value1, String value2, Color color,
    BoxConstraints constraints, String userId, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    padding: calculatePadding(
        constraints.maxWidth, 0.02, constraints.maxHeight, 0.02),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            key,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: calculateFontSize(constraints.maxHeight, 0.02),
              color: textColor,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: calculateFontSize(constraints.maxHeight, 0.02),
              color: textColor,
            ),
          ),
        ),
        // Display a check mark if the topic_status is "Completed"
        IconButton(
          icon: Icon(
            value2 == "Completed"
                ? Icons.check_circle
                : Icons.check_circle_outline,
            color: value2 == "Completed" ? Colors.green : Colors.grey,
            size: 24, // Adjust the icon size as needed
          ),
          onPressed: () async {
            if (value2 != "Completed") {
              try {
                await Supabase.instance.client
                    .from("Course Outline")
                    .update({
                      "topic_status": "Completed",
                    })
                    .eq("topic_name", key)
                    .eq("teacher_id", userId);

                showErrorDialog(context, "Topic status updated successfully.");
              } catch (e) {
                showErrorDialog(context, "Error: $e");
              }
            } else {
              try {
                final response = await Supabase.instance.client
                    .from("Course Outline")
                    .update({
                      "topic_status": "Not Completed",
                    })
                    .eq("topic_name", key)
                    .eq("teacher_id", userId);

                if (response.isEmpty) {
                  showErrorDialog(context,
                      "Error updating status: ${response.error?.message}");
                } else {
                  showErrorDialog(
                      context, "Topic status updated successfully.");
                  // Optionally, trigger a UI update if needed
                }
              } catch (e) {
                showErrorDialog(context, "Error: $e");
              }
            }
          },
        ),
      ],
    ),
  );
}

List<Widget> updateDataRows(LinkedHashMap<String, List<dynamic>> inputDataRows,
    BoxConstraints constraints, String userId, BuildContext context) {
  List<Widget> dataRows = [];
  int dataRowCount = inputDataRows.length;
  int currentIndex = 0;

  inputDataRows.forEach((key, value) {
    dataRows.add(updateDataRow(
        key, value[0], value[1], buttonColor, constraints, userId, context));
    currentIndex++;

    if (currentIndex < dataRowCount) {
      dataRows.add(SizedBox(
        height: constraints.maxHeight * 0.01,
      ));
    }
  });

  return dataRows;
}

Widget showAttRow(String key, String value1, String value2, String value3,
    Color color, BoxConstraints constraints, String userId) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    padding: calculatePadding(
        constraints.maxWidth, 0.02, constraints.maxHeight, 0.02),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            key,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: calculateFontSize(constraints.maxHeight, 0.02),
              color: textColor,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: calculateFontSize(constraints.maxHeight, 0.02),
              color: textColor,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: calculateFontSize(constraints.maxHeight, 0.02),
              color: textColor,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value3,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: calculateFontSize(constraints.maxHeight, 0.02),
              color: textColor,
            ),
          ),
        ),
      ],
    ),
  );
}

List<Widget> showAttRows(LinkedHashMap<String, List<dynamic>> inputDataRows,
    BoxConstraints constraints, String userId) {
  List<Widget> dataRows = [];
  int dataRowCount = inputDataRows.length;
  int currentIndex = 0;

  inputDataRows.forEach((key, value) {
    dataRows.add(showAttRow(
        key, value[0], value[1], value[2], buttonColor, constraints, userId));
    currentIndex++;

    if (currentIndex < dataRowCount) {
      dataRows.add(SizedBox(
        height: constraints.maxHeight * 0.01,
      ));
    }
  });

  return dataRows;
}
