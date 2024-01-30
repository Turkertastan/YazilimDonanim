import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class kaydol extends StatefulWidget {
  const kaydol({Key? key}) : super(key: key);

  @override
  _KaydolState createState() => _KaydolState();
}

class _KaydolState extends State<kaydol> with SingleTickerProviderStateMixin {
   late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _showPassword = true;
  final TextEditingController _controllerMail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerIsim = TextEditingController();
  final TextEditingController _controllerSoyisim = TextEditingController();

  Future<void> _kullaniciyiKaydet(
      {required String email,
      required String password,
      required String isim,
      required String soyisim}) async {
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection("kullanicilar")
          .doc(user.user?.uid)
          .set({
        "isim": isim,
        "soyisim": soyisim,
        "email": email,
        "uid": user.user?.uid,
      });

      // Kullanıcı başarıyla kaydedildiğinde animasyonu başlat
      _animationController.reset();
      _animationController.forward();

      // SnackBar ile başarılı kayıt mesajını göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kullanıcı başarıyla kaydedildi."),
          backgroundColor: Colors.green,
        ),
      );

      // Kullanıcı başarıyla kaydedildikten sonra geri dön
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Kullanıcı kaydederken bir hata olursa, hatayı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // _fadeAnimation'ı başlat
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Colors.black, Colors.purple, Colors.blue],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hoşgeldiniz", style: TextStyle(color: Colors.white, fontSize: 40)),
                    SizedBox(height: 10),
                    Text("Kaydol", style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      _buildTextField(_controllerMail, "Mail adresinizi giriniz", TextInputType.emailAddress),
                      _buildTextField(_controllerPassword, "Şifre", TextInputType.text, obscureText: _showPassword),
                      _buildTextField(_controllerIsim, "İsim", TextInputType.text),
                      _buildTextField(_controllerSoyisim, "Soyisim", TextInputType.text),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              minimumSize: const Size(200, 50),
                            ),
                            onPressed: () async {
                              final mail = _controllerMail.text;
                              final password = _controllerPassword.text;
                              final Isim = _controllerIsim.text;
                              final Soyisim = _controllerSoyisim.text;
                              print("$mail $password");
                              await _kullaniciyiKaydet(email: mail, password: password, isim: Isim, soyisim: Soyisim);
                            },
                            child: const Text("Kaydol", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.arrow_back_rounded), Text("Giriş yap")],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController? controller, String hintText, TextInputType inputType, {bool obscureText = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
        obscureText: obscureText, // Burada _showPassword kullanılmamış
        decoration: InputDecoration(
          suffixIcon: obscureText
              ? IconButton(
                  onPressed: () {
                    if (obscureText) {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    }
                  },
                  icon: Icon(obscureText ? (_showPassword ? Icons.visibility : Icons.visibility_off) : null),
                )
              : null,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}