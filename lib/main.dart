import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/bildirimler.dart';
import 'package:my_flutter_app/firebase_options.dart';
import 'package:my_flutter_app/logogiris.dart';
import 'package:my_flutter_app/service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    
  );
  await FirebaseNotificationService().connectNotification();
  runApp(MyApp());
}

class Tema extends ChangeNotifier {
  static Tema? _instance;
  ThemeData _mode = ThemeData.light();

  factory Tema() {
    _instance ??= Tema._internal();
    return _instance!;
  }

  Tema._internal();

  ThemeData get theme => _mode;

  void darkmode() {
    _mode = _mode == ThemeData.dark() ? ThemeData.light() : ThemeData.dark();
    print("object $_mode");
    notifyListeners();
  }
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Tema _tema = Tema();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _tema,
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home:  const LogoGirisi(),
            theme: _tema.theme
            // darkTheme: darkMode,
            );
      },
    );
  }
}
