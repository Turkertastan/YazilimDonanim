import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final  VoidCallback onLogout;
   
  
  const ProfileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onLogout,
  });

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    print("asdasd");
    return ListTile(
      leading:  Icon(widget.icon),
      title:  Text(widget.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: widget.onLogout,
      
    );
  }
}
