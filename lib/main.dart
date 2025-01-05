import "package:flutter/material.dart";
import "screens/start_screen.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:flutter/services.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://wmzxftvbydulevktmely.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtenhmdHZieWR1bGV2a3RtZWx5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI4NDY0MzMsImV4cCI6MjA0ODQyMjQzM30.bXLMP_C0OuwrJibmvAumqgxoQrshdryzKN95VWum_po",
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "KGFont2",
      ),
      home: const StartScreen(),
    );
  }
}
