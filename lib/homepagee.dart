import 'package:flutter/material.dart';
class homePagee extends StatefulWidget {
  const homePagee({super.key});

  @override
  State<homePagee> createState() => _homePageeState();
}

class _homePageeState extends State<homePagee> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("anasayfa"),
      ),
    );
  }
}