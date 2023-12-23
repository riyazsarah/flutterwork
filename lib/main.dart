import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth/phone_numb_screen.dart';

import 'package:provider/provider.dart';
import 'auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
     create: (context) => AuthProvider(),
     child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PureFarm Milk',
      theme: ThemeData(
        fontFamily: GoogleFonts.didactGothic().fontFamily,
         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          error: const Color.fromARGB(255, 255, 74, 64), // Set your desired error color here
          ),
          useMaterial3: true, 
      ),
      home: const PhoneNumberScreen(),
    );
  }
}


