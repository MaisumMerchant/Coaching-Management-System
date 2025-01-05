import "package:coaching_management_system/screens/attendance_screen.dart";
import "package:coaching_management_system/screens/course_outline_screen.dart";
import "package:coaching_management_system/screens/profile_screen.dart";
import "package:flutter/material.dart";
import "../components/glass_container.dart";
import "../utils/constants.dart";
import "../utils/utils.dart";
import 'dart:collection';

class DashboardScreen extends StatefulWidget {
  final int userType;
  final String userId;

  const DashboardScreen(
      {required this.userType, required this.userId, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final LinkedHashMap<String, ButtonConfig> inputButtons;

  @override
  void initState() {
    super.initState();

    final userType = widget.userType;
    final userId = widget.userId;

    inputButtons = LinkedHashMap.from({
      if (userType == 0) ...{
        "Student Profile": ButtonConfig(
          onTap: () => navigateToPage(
              context, ProfileScreen(userType: userType, userId: userId)),
          color: buttonColor,
        ),
      } else if (userType == 1) ...{
        "Teacher Profile": ButtonConfig(
          onTap: () => navigateToPage(
              context, ProfileScreen(userType: userType, userId: userId)),
          color: buttonColor,
        ),
        "Course Outline": ButtonConfig(
          onTap: () => navigateToPage(
              context, CourseOutlineScreen(userType: userType, userId: userId)),
          color: buttonColor,
        ),
      } else ...{
        "Admin Profile": ButtonConfig(
          onTap: () => navigateToPage(
              context, ProfileScreen(userType: userType, userId: userId)),
          color: buttonColor,
        ),
        "Course Outline": ButtonConfig(
          onTap: () => navigateToPage(
              context, CourseOutlineScreen(userType: userType, userId: userId)),
          color: buttonColor,
        ),
      },
      "TimeTable": ButtonConfig(
        onTap: () => print("TimeTable"),
        color: buttonColor,
      ),
      "Result": ButtonConfig(
        onTap: () => print("Result"),
        color: buttonColor,
      ),
      "Attendance Record": ButtonConfig(
        onTap: () => navigateToPage(
            context, AttendanceScreen(userType: userType, userId: userId)),
        color: buttonColor,
      ),
      "Log Out": ButtonConfig(
        onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
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
                  constraints.maxWidth,
                  0.05,
                  constraints.maxHeight,
                  0.05,
                ),
                child: Center(
                  child: GlassContainer(
                    blur: blur,
                    opacity: opacity,
                    color: glassColor,
                    borderRadius: borderRadius,
                    borderWidth: borderWidth,
                    child: Padding(
                      padding: calculatePadding(
                        constraints.maxWidth,
                        0.05,
                        constraints.maxHeight,
                        0.05,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            getDashboardTitle(widget.userType),
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
