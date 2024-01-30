import 'package:flutter/material.dart';
import 'package:my_flutter_app/yuk_ismakine_ilanver.dart';
import 'package:my_flutter_app/bildirimler.dart';
import 'package:my_flutter_app/destek_iletisim.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/search.dart';

class YeniAnasayfa extends StatefulWidget {
  const YeniAnasayfa({Key? key}) : super(key: key);

  @override
  _YeniAnasayfaState createState() => _YeniAnasayfaState();
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await firestore.collection('kullanicilar').doc(user.uid).get();

        if (documentSnapshot.exists) {
          String isim = documentSnapshot['isim'];
          String soyisim = documentSnapshot['soyisim'];

          await user.updateProfile(displayName: '$isim $soyisim');

          setState(() {
            _currentUser = user;
          });
        } else {
          setState(() {
            _currentUser = user;
          });
        }
      } catch (e) {
        print('Hata oluştu: $e');
      }
    } else {
      setState(() {
        _currentUser = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: _currentUser != null
                ? Text(_currentUser!.displayName ?? "isim")
                : const Text(""),
            accountEmail: _currentUser != null
                ? Text(_currentUser!.email ?? "email")
                : const Text(""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset("assets/logo.png"),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/ucuncu.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTileWithAnimation(
            icon: Icons.list,
            title: "Yük İlanı Ver",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GirisEkrani()),
              );
            },
          ),
          ListTileWithAnimation(
            icon: Icons.fire_truck,
            customIcon: Image.asset("assets/excavator.png"),
            title: "İlanlar",
            onTap: () {
              // Tıklama işlemleri
            },
          ),
          ListTileWithAnimation(
            icon: Icons.notifications,
            title: "Bildirimler",
            onTap: () {},
          ),
          ListTileWithAnimation(
            icon: Icons.email,
            title: "Destek ve İletişim",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DestekIletisim(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ListTileWithAnimation extends StatelessWidget {
  final IconData icon;
  final Widget? customIcon;
  final String title;
  final VoidCallback onTap;

  const ListTileWithAnimation({
    Key? key,
    required this.icon,
    this.customIcon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeInOut,
        ),
      ),
      child: ListTile(
        leading: customIcon ?? Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}

class _YeniAnasayfaState extends State<YeniAnasayfa>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
  icon: Icon(
    Icons.message,
    color: Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white,
  ),
  onPressed: () {
    // Kullanıcının tıkladığında ilgili ilan sahibinin UID'sini ileterek yeni sayfaya geçiş yapın.
   
  },
),

        ],
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: screenSize.width,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        "Yük Cepte",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        "Anasayfa",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                    Container(
                      width: screenSize.width * 0.8,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onEditingComplete: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SearchPage(
                                    aramaIstegi: _searchController.text,
                                  )));
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                          ),
                          hintText: "Kullanıcı Ara",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Yük cepte !",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          PromoCardWithAnimation(
                              "assets/asd.jpg", _fadeAnimation),
                          PromoCardWithAnimation(
                              "assets/ikinci.jpg", _fadeAnimation),
                          PromoCardWithAnimation(
                              "assets/ucuncu.jpg", _fadeAnimation),
                          PromoCardWithAnimation(
                              "assets/tasiyici.jpg", _fadeAnimation),
                          PromoCardWithAnimation(
                              "assets/yuk.jpg", _fadeAnimation),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: screenSize.height * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/limanyuk.jpg"),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            stops: const [0.2, 0.9],
                            colors: [
                              Colors.black.withOpacity(.8),
                              Colors.black.withOpacity(.1),
                            ],
                          ),
                        ),
                      ),
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

Widget PromoCardWithAnimation(String image, Animation<double> animation) {
  return FadeTransition(
    opacity: animation,
    child: AspectRatio(
      aspectRatio: 2.6 / 3,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              stops: const [0.2, 0.9],
              colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.1),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
