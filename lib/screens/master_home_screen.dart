import 'package:flutter/material.dart';

class MasterHomeScreen extends StatelessWidget {
  const MasterHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мастер'),
        backgroundColor: const Color(0xFF17A2B8),
      ),
      body: const Center(
        child: Text(
          'Экран для Мастера\n(в разработке)',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF7F8C8D),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
