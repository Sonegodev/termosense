import 'package:flutter/material.dart';
import 'package:termosense/style/colors.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.azul, AppColors.branco],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.6, 2],
          ),
        ),
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset(
                'assets/images/botaoicon.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
