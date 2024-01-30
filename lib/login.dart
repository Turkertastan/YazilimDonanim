import 'package:flutter/material.dart';
import 'package:my_flutter_app/yuk_ismakine_ilanver.dart';
import 'package:my_flutter_app/homepagee.dart';
import 'package:my_flutter_app/kaydol_buton.dart';
import 'package:my_flutter_app/sifre_sifirla.dart';
import 'package:my_flutter_app/yeni_navigation.dart';
import 'package:my_flutter_app/yenigiris.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  bool _showPassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Animasyonu başlatmak için
    _animationController.forward();
  }

  Future<void> _girisYap() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("Giriş başarılı! User ID: ${userCredential.user?.uid}");

      // Başarılı girişin ardından yapılacak işlemleri ekleyebilirsiniz.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const newNavigationbar(),
        ),
      );
    } catch (e) {
      print("Giriş hatası: $e");
      setState(() {
        _errorMessage = "Hatalı kullanıcı adı veya şifre";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hoşgeldiniz",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40 * _fadeAnimation.value,
                          ),
                        ),
                        SizedBox(height: 10 * _fadeAnimation.value),
                        Text(
                          "Giriş Yap",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20 * _fadeAnimation.value,
                          ),
                        ),
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
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(160, 148, 139, 0.6),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                buildTextField(
                                  controller: _emailController,
                                  hintText: "Gmail",
                                ),
                                buildTextField(
                                  controller: _passwordController,
                                  hintText: "Şifre",
                                  isPassword: true,
                                  showPassword: _showPassword,
                                  toggleShowPassword: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                ),
                                if (_errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      _errorMessage,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          InkWell(
                            splashColor: Colors.amber,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SifreSifirlama()),
                              );
                            },
                            child: Container(
                              child: const Text(
                                "Şifremi unuttum?",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              minimumSize: const Size(200, 50),
                            ),
                            onPressed: _girisYap,
                            child: const Text(
                              "Giriş",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              minimumSize: const Size(200, 50),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const kaydol(),
                                ),
                              );
                            },
                            child: const Text(
                              "Kaydol",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool showPassword = false,
    VoidCallback? toggleShowPassword,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !showPassword,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: toggleShowPassword,
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
