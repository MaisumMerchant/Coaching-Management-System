import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/glass_container.dart';
import 'dart:collection';

class CourseOutlineScreen extends StatefulWidget {
  final int userType;
  final String userId;

  const CourseOutlineScreen(
      {required this.userType, required this.userId, super.key});

  @override
  State<CourseOutlineScreen> createState() => _CourseOutlineScreenState();
}

class _CourseOutlineScreenState extends State<CourseOutlineScreen> {
  late LinkedHashMap<String, List<dynamic>> dataRows =
      LinkedHashMap<String, List<dynamic>>();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourseOutline();
  }

  Future<void> _fetchCourseOutline() async {
    try {
      final PostgrestList courseOutline;
      if (widget.userType == 1) {
        courseOutline = await Supabase.instance.client
            .from("Course Outline")
            .select()
            .eq("teacher_id", widget.userId);
      } else {
        courseOutline =
            await Supabase.instance.client.from("Course Outline").select();
      }
      for (var topic in courseOutline) {
        dataRows[topic["topic_name"] ?? 'Unknown'] = [
          topic["topic_date"] ?? 'No Date',
          topic["topic_status"] ?? 'Unknown Status'
        ];
      }
    } catch (e) {
      showErrorDialog(context, "Error fetching course outline: $e");
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
                                children: updateDataRows(dataRows, constraints,
                                    widget.userId, context),
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
