import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/glass_container.dart';
import 'dart:collection';

class AttendanceScreen extends StatefulWidget {
  final int userType;
  final String userId;

  const AttendanceScreen(
      {required this.userType, required this.userId, super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late LinkedHashMap<String, List<String>> attendanceData =
      LinkedHashMap<String, List<String>>();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    try {
      final PostgrestList attendanceList;
      if (widget.userType == 0) {
        attendanceList = await Supabase.instance.client
            .from("Attendance")
            .select()
            .eq("student_id", widget.userId);
      } else if (widget.userType == 1) {
        attendanceList = await Supabase.instance.client
            .from("Attendance")
            .select()
            .eq("student_id", widget.userId);
      } else {
        attendanceList =
            await Supabase.instance.client.from("Attendance").select();
      }
      for (var attendance in attendanceList) {
        attendanceData[attendance["attendance_id"]] = [
          attendance["attendance_date"],
          attendance["attendance_day"],
          attendance["attendance_status"]
        ];
      }
    } catch (e) {
      showErrorDialog(context, "Error fetching attendance data: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
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
                            child: SingleChildScrollView(
                              child: Column(
                                children: showAttRows(
                                    attendanceData, constraints, widget.userId),
                              ),
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
