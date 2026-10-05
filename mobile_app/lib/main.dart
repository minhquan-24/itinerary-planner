import 'package:flutter/material.dart';
import 'screens/trip_detail_screen.dart';

void main() {
  runApp(const LocalItineraryPlannerApp());
}

class LocalItineraryPlannerApp extends StatelessWidget {
  const LocalItineraryPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trợ lý Lên lịch Trải nghiệm & Hội ngộ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
          secondary: Colors.amber,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FA),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Color(0xFFF7F9FA),
        ),
      ),
      home: const TripDetailScreen(),
    );
  }
}
