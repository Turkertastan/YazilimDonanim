import 'package:flutter/material.dart';
import 'package:my_flutter_app/service.dart';
class Bildirimler extends StatefulWidget {
  const Bildirimler({super.key});

  @override
  State<Bildirimler> createState() => _BildirimlerState();
}

class _BildirimlerState extends State<Bildirimler> {
  final _service = FirebaseNotificationService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _service.connectNotification();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("bildirim"),
      ),
    );
  }
}