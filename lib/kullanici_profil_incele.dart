import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class KullaniciProfilSayfasi extends StatefulWidget {
  final String kullaniciIsmi;
  final String uid;

  const KullaniciProfilSayfasi({
    Key? key,
    required this.kullaniciIsmi,
    required this.uid,
  }) : super(key: key);

  @override
  _KullaniciProfilSayfasiState createState() => _KullaniciProfilSayfasiState();
}

class _KullaniciProfilSayfasiState extends State<KullaniciProfilSayfasi> {
  String number = "";
  String isteTelefon = "";
  String adres = "";
  String gecmis = "";
  String isDurumu = "";
  double userRating = 0.0;
  double averageRating = 0.0; // Ortalama puan
  Map<String, dynamic> _user = {};
  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  Future<void> _getUserDetails() async {
  final response = await FirebaseFirestore.instance
      .collection('kullanicilar')
      .doc(widget.uid)
      .get();
  _user = response.data() ?? {};
  if (_user.isNotEmpty) {
    setState(() {
      // Kullanıcı bilgilerini güncelle
      number = _user["number"] ?? "";
      isteTelefon = _user["istelefon"] ?? "";
      adres = _user["adres"] ?? "";
      gecmis = _user["gecmis"] ?? "";

      var isDurumuList = _user["isdurumu"] ?? [];
      isDurumu = isDurumuList.isNotEmpty ? isDurumuList.join(', ') : "";
    });

    _getAverageRating();
  } else {
    print("EMPTY");
  }
}


  void _getAverageRating() {
    print("EVET");

    double puanToplami = _user["puantoplami"];
    int puanVeren = _user["puanveren"];

    setState(() {
      if (puanVeren > 0) {
        averageRating = puanToplami / puanVeren;
      }
    });

    print("HERŞEY $averageRating $puanVeren $puanToplami");
  }

  Future<void> _updateRating(double rating) async {
    // Kullanıcıyı puanlamak için Firebase'de güncelleme yap
    await FirebaseFirestore.instance
        .collection('kullanicilar')
        .doc(widget.uid)
        .update({
      'puan': averageRating, // Ortalama puanı güncelle
      'puantoplami': FieldValue.increment(rating),
      'puanveren': FieldValue.increment(1),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Profili'),
        backgroundColor: Colors.grey.shade500,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Card'a tıklanıldığında bir şey yapmak istiyorsanız buraya ekleyebilirsiniz
          },
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.all(25),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/logo.png"),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.kullaniciIsmi,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ortalama Puan: ${averageRating.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  buildRow(Icons.phone_android, 'Cep Telefonu: $number'),
                  const SizedBox(height: 20),
                  buildRow(Icons.call, 'İş Telefonu: $isteTelefon'),
                  const SizedBox(height: 20),
                  buildRow(Icons.location_on, 'Adres: $adres'),
                  const SizedBox(height: 20),
                  buildRow(Icons.description, 'Geçmiş: $gecmis'),
                  const SizedBox(height: 20),
                  buildRow(Icons.check, 'İş Durumu: $isDurumu'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating: userRating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            userRating = rating;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          // Puanı güncelle ve Firebase'e kaydet
                          await _updateRating(userRating);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Puanınız başarıyla kaydedildi!'),
                            ),
                          );
                        },
                        child: const Icon(Icons.arrow_outward),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
