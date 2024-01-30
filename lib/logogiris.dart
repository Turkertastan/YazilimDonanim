import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/login.dart';
import 'package:my_flutter_app/yeni_navigation.dart';



class LogoGirisi extends StatefulWidget {
  const LogoGirisi({Key? key}) : super(key: key);

  @override
  _LogoGirisiState createState() => _LogoGirisiState();
}

class _LogoGirisiState extends State<LogoGirisi> {
  late final User? user;

 @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
   
    // 4 saniye sonra setState ile logoVisible'ı false yaparak logo kaybolur
    Future.delayed(const Duration(seconds: 4), () {
       if(user != null){
      
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const newNavigationbar(),), (route) => false);
    }else{
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Login(),), (route) => false);
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
