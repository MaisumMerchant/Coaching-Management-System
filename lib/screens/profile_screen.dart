import 'package:flutter/material.dart';
import '../components/glass_container.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'dart:collection';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final int userType;
  final String userId;

  const ProfileScreen(
      {required this.userType, required this.userId, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late LinkedHashMap<String, dynamic> dataRows =
      LinkedHashMap<String, String>();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final userType = widget.userType;
    final userId = widget.userId;

    try {
      if (userType == 0) {
        final studentData = await Supabase.instance.client
            .from("Students")
            .select()
            .eq("student_id", userId)
            .single();

        // Create a list of course IDs dynamically to handle null checks
        List<Future<Map<String, dynamic>>> courseFutures = [];
        for (int i = 1; i <= 7; i++) {
          final courseId = studentData["course_$i"];
          if (courseId != null) {
            courseFutures.add(
              Supabase.instance.client
                  .from("Courses")
                  .select("course_name")
                  .eq("course_id", courseId)
                  .single()
                  .then((course) => course),
            );
          } else {
            // If course ID is null, add a dummy future for a "N/A" entry
            courseFutures.add(Future.value({"course_name": "N/A"}));
          }
        }

        // Wait for all course data to load
        final coursesData = await Future.wait(courseFutures);

        // Construct dataRows with the fetched data
        dataRows = LinkedHashMap.from({
          "Name": studentData["student_name"] ?? "N/A",
          "Father Name": studentData["student_father_name"] ?? "N/A",
          "Contact # 1": studentData["contact_1"] ?? "N/A",
          "Contact # 2": studentData["contact_2"] ?? "N/A",
          "Class": studentData["student_class"] ?? "N/A",
          "Course # 1": coursesData[0]["course_name"] ?? "N/A",
          "Course # 2": coursesData[1]["course_name"] ?? "N/A",
          "Course # 3": coursesData[2]["course_name"] ?? "N/A",
          "Course # 4": coursesData[3]["course_name"] ?? "N/A",
          "Course # 5": coursesData[4]["course_name"] ?? "N/A",
          "Course # 6": coursesData[5]["course_name"] ?? "N/A",
          "Course # 7": coursesData[6]["course_name"] ?? "N/A",
        });
      } else if (userType == 1) {
        final teacherData = await Supabase.instance.client
            .from("Teachers")
            .select()
            .eq("teacher_id", userId)
            .single();
        // Fetch the courses that the teacher is associated with
        final teacherCoursesData = await Supabase.instance.client
            .from("Courses")
            .select("class, course_name")
            .eq("teacher_id", userId);

        // Create a formatted string for courses
        String coursesString = "";
        for (var course in teacherCoursesData) {
          String classInfo =
              "${course["class"] ?? "N/A"} (${course["course_name"] ?? "N/A"})";
          if (coursesString.isNotEmpty) {
            coursesString += ", ";
          }
          coursesString += classInfo;
        }

        dataRows = LinkedHashMap.from({
          "Name": teacherData["teacher_name"] ?? "N/A",
          "Courses": coursesString.isNotEmpty ? coursesString : "N/A",
        });
      } else {
        final adminData = await Supabase.instance.client
            .from("Admins")
            .select()
            .eq("admin_id", userId)
            .single();
        dataRows = LinkedHashMap.from({
          "Name": adminData["admin_name"] ?? "N/A",
          "Role": adminData["admin_role"] ?? "N/A",
          "Task": adminData["admin_task"] ?? "N/A",
        });
      }
    } catch (e) {
      // Handle error, log or display it
      showErrorDialog(context, "Error fetching data: $e");
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
                                children: buildDataRows(dataRows, constraints),
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
