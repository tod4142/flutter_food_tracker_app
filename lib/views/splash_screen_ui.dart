// ignore_for_file: unnecessary_const, unused_import, use_build_context_synchronously, annotate_overrides

import 'package:flutter/material.dart';
import 'package:flutter_food_tracker/views/show_all_food_ui.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ShowAllFoodUI(),
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 67, 54),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/burger.png',
                  height: MediaQuery.of(context).size.width * 0.45,
                  width: MediaQuery.of(context).size.width * 0.45,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Text(
                  'FOOD TRACKER',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 235, 59),
                    fontSize: MediaQuery.of(context).size.height * 0.035,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  '🍕🍔🍟🌭🍿🥓🥐',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 235, 59),
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                const CircularProgressIndicator(
                  color: const Color.fromARGB(255, 255, 235, 59),
                ),
              ],
            ),
          ),
          //ชั้น 2 แสดง ข้อความ copy right
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Copyright © 2026 FOOD TRACKER',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 235, 59),
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                  ),
                ),
                Text(
                  'Created by Rattanachai.',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 235, 59),
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
