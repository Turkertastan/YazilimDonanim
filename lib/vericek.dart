import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class VeriCek extends StatefulWidget {
  const VeriCek({super.key});

  @override
  State<VeriCek> createState() => _VeriCekState();
}

class _VeriCekState extends State<VeriCek> {

  Future<void> Ilanlar() async {
    final response = await FirebaseFirestore.instance.collection("ilanlar").get();
    print(response.docs.length);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gecmis İlanlar"),
      ),
      body: Center(
        child: ElevatedButton(onPressed: () {
          Ilanlar();
        }, child: const Text("veriler")),
      ),
    );
  }
}