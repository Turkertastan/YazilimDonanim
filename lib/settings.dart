import 'package:flutter/material.dart';
import 'package:my_flutter_app/main.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
bool darkmode = false;
  final Tema _tema = Tema();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: const Text("Ayarlar"),
      ),
      body: Center(
        child: SwitchListTile(
            title: const Text("Karanlık mod"),
            value: darkmode,
            onChanged: (value) {
              setState(() {
                _tema.darkmode();
                darkmode = value;
              });
            },
          ),
      ),

    );
  }
}