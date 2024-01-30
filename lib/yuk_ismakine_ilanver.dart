import 'package:flutter/material.dart';
import 'package:my_flutter_app/ismakinesi.dart';
import 'package:my_flutter_app/yenigiris.dart';
import 'package:my_flutter_app/yükverenilan.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({Key? key}) : super(key: key);

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 146, 141, 134),
        title: Center(child: isSearched ? const TextField() : const Text("")),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cards(
                context,
                "assets/tasiyici.jpg",
                "Nakliye ilanı Ver",
                Colors.black,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const yukveren(),
                  ),
                ),
              ),
              cards(
                context,
                "assets/ismakinesi.jpeg",
                "İş makinesi mi lazım ?",
                Colors.black,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ismakinasi(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget cards(
  BuildContext context,
  String image,
  String butonismi,
  Color color,
  void Function()? onPressed,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 150, 142, 134),
                ),
                onPressed: onPressed,
                child: Text(
                  butonismi,
                  style: TextStyle(color: color),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
