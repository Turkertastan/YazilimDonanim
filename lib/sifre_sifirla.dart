import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SifreSifirlama extends StatefulWidget {
  const SifreSifirlama({super.key});

  @override
  State<SifreSifirlama> createState() => _SifreSifirlamaState();
}

class _SifreSifirlamaState extends State<SifreSifirlama> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    final String email = _emailController.text.trim();

    try {
      // Kullanıcının varlığını kontrol et
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: 'dummy-password');

      // Kullanıcı varsa şifre sıfırlama emaili gönder
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Başarılı ise
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Şifre sıfırlama linki emailinize gönderildi.'),
        ),
      );
    } catch (e) {
      // Hata durumunda
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        // Kullanıcı kayıtlı değilse
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Geçersiz email adresi: $email'),
          ),
        );
      } else {
        // Diğer hata durumları
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Şifre sıfırlama başarısız. Hata: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Sıfırlama'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Şifre Sıfırla'),
            ),
          ],
        ),
      ),
    );
  }
}
