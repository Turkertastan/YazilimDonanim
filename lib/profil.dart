import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore için eklenen import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/gecmis_aktivite.dart';
import 'package:my_flutter_app/kullanici_bilgileri.dart';
import 'package:my_flutter_app/login.dart';
import 'package:my_flutter_app/profile_widget.dart';
import 'package:my_flutter_app/settings.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class profil extends StatefulWidget {
  const profil({super.key});

  @override
  State<profil> createState() => _profilState();
}

class _profilState extends State<profil> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  double userRating = 0.0; // Kullanıcının puanını saklamak için

  // Kullanıcı verilerini tutacak değişkenler
  late String isim = "";
  late String soyisim = "";
  late String email = "";

  bool isRatingLoaded =
      false; // Puanın yüklenip yüklenmediğini kontrol etmek için

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();

    // Firestore'dan kullanıcı verilerini çekme işlemi
    _loadUserData();
  }

  // Firestore'dan kullanıcı verilerini çeken metod
 Future<void> _loadUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('kullanicilar')
        .doc(user.uid)
        .get();

    // Firestore'dan alınan verileri değişkenlere atama
    setState(() {
      isim = userSnapshot['isim'] ?? ""; // isim alanını kontrol et
      soyisim = userSnapshot['soyisim'] ?? ""; // soyisim alanını kontrol et
      email = user.email ?? ""; // Kullanıcının emailini alıyoruz

      if (!isRatingLoaded && userSnapshot.exists) {
        userRating = userSnapshot['puan'] ?? 0.0; // puan alanını kontrol et
        isRatingLoaded = true;
      }
    });
  }else{
    print("NUOLLLLLLLLLL");
  }
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: const Color.fromARGB(255, 146, 141, 134),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(.5),
                    width: 5.0,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$isim $soyisim", // isim ve soyisim alanlarını birleştirme
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  email,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              SlideTransition(
                position: _offsetAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      itemSize: 20,
                      initialRating: userRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          userRating = rating;
                        });
                        // Puanı güncelle ve Firebase'e kaydet
                        saveUserRating(rating);
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileWidget(
                      icon: Icons.fire_truck,
                      title: "İlanlarınız",
                      onLogout: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const GecmisAktiviteler(),
                        ));
                      },
                    ),
                    ProfileWidget(
                      icon: Icons.person,
                      title: "Kullanıcı Bilgileri",
                      onLogout: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const KullaniciBilgileri(),
                        ));
                      },
                    ),
                    ProfileWidget(
                      icon: Icons.settings,
                      title: "Ayarlar",
                      onLogout: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const settings(),
                        ));
                      },
                    ),
                    ProfileWidget(
                      icon: Icons.logout,
                      title: "Çıkış yap",
                      onLogout: () async {
                        await cikisYap();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> saveUserRating(double rating) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance
        .collection('kullanicilar')
        .doc(user.uid)
        .update({'puan': rating});
  }
}

Future<void> cikisYap() async {
  await FirebaseAuth.instance.signOut();
}
