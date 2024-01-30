import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_flutter_app/core/custom_bottom_sheet.dart';

class GecmisAktiviteler extends StatefulWidget {
  const GecmisAktiviteler({Key? key}) : super(key: key);

  @override
  State<GecmisAktiviteler> createState() => _GecmisAktivitelerState();
}

class _GecmisAktivitelerState extends State<GecmisAktiviteler> {
  List<Ilan> ilanlar = [];

  @override
  void initState() {
    super.initState();
    _yuklemeIslemleriniTamamla();
  }

  Future<void> _yuklemeIslemleriniTamamla() async {
    await ilanlariGetir();
    setState(() {});
  }

  Future<void> ilanlariGetir() async {
    final useremail = FirebaseAuth.instance.currentUser;
    try {
      print("İlanlar yükleniyor...");
      final veriCekme = await FirebaseFirestore.instance
          .collection("ilanlar")
          .where("ilansahibi", isEqualTo: useremail!.email)
          .get();
      final dokumanlar = veriCekme.docs;

      for (var element in dokumanlar) {
        final data = element.data();
        final tarihCekme = data["yuklemeTarihi"];
        final DateTime? tarih = tarihCekme?.toDate();

        final aciklama = data["Açıklama"] as String? ?? "Açıklama yok";

        ilanlar.add(Ilan(
          yuk: data["yükü"] ?? "",
          tonaj: data["yüktonajı"] ?? "",
          yuklemeYeri: data["yüklemeyeri"] ?? "",
          bosaltmaYeri: data["bosaltmayeri"] ?? "",
          arac: data["hangiarac"] ?? "",
          yuklemeTarihi: tarih,
          aciklama: aciklama,
        ));
      }

      print("İlanlar yüklendi!");
    } catch (e) {
      print("Hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: const Text('Geçmiş İlanlar'),
      ),
      body: _buildIlanListesi(),
    );
  }

  Widget _buildIlanListesi() {
    return ilanlar.isEmpty
        ? const IlanYokWidget()
        : ListView.builder(
            itemCount: ilanlar.length,
            itemBuilder: (context, index) {
              return TasiyiciCard(ilan: ilanlar[index]);
            },
          );
  }
}

class IlanYokWidget extends StatelessWidget {
  const IlanYokWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.calendar_month, size: 45, color: Colors.grey),
          ),
          Text(
            "Hiç İlan Bulunamadı",
            style: TextStyle(
                fontSize: 27, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class Ilan {
  final String yuk;
  final String tonaj;
  final String yuklemeYeri;
  final String bosaltmaYeri;
  final String arac;
  final DateTime? yuklemeTarihi;
  final String aciklama;

  Ilan({
    required this.yuk,
    required this.tonaj,
    required this.yuklemeYeri,
    required this.bosaltmaYeri,
    required this.arac,
    required this.yuklemeTarihi,
    required this.aciklama,
  });
}

class TasiyiciCard extends StatelessWidget {
  final Ilan ilan;

  const TasiyiciCard({
    Key? key,
    required this.ilan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 10,
        color: Colors.grey.shade400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: 180,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LocationWidgets(
                        yuklemeYeri: ilan.yuklemeYeri,
                        bosaltmaYeri: ilan.bosaltmaYeri,
                      ),
                      _yukTuru(),
                      _ilanTarihi(),
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: Divider(
                  color: Colors.white,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _tonaj(),
                      _customDivider(),
                      _aracTuru(),
                      _customDivider(),
                      ElevatedButton.icon(
                        onPressed: () {
                          customBottomSheet(
                            context: context,
                            height: 400,
                            child: Text(ilan.aciklama),
                          );
                        },
                        icon: const Icon(Icons.chevron_right_rounded),
                        label: const Text("Detay"),
                      )
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

  Container _customDivider() => Container(
        height: 25,
        width: 1,
        color: Colors.grey,
      );

  Column _aracTuru() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Arac Türü"),
          Expanded(child: Text(ilan.arac)),
        ],
      );

  Column _tonaj() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [const Text("Tonaj"), Text(ilan.tonaj)],
    );
  }

  Widget _yukTuru() {
    String arac = ilan.arac.toLowerCase();

    AssetImage aracImage;
    if (arac.contains("tır")) {
      aracImage = const AssetImage("assets/tır-removebg-preview.png");
    } else if (arac.contains("kamyon")) {
      aracImage = const AssetImage("assets/kamyonn.png");
    } else if (arac.contains("pikap")) {
      aracImage = const AssetImage("assets/pikap.png");
    } else if (arac.contains("kırkayak")) {
      aracImage = const AssetImage("assets/kırkayakk.png");
    } else {
      aracImage = const AssetImage("assets/varsayilan-image.png");
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image(height: 30, image: aracImage),
      ],
    );
  }

  Column _ilanTarihi() {
    return Column(
      children: [
        Text(
          ilan.yuklemeTarihi != null
              ? ' ${ilan.yuklemeTarihi!.day}-${ilan.yuklemeTarihi!.month}-${ilan.yuklemeTarihi!.year}'
              : 'Tarih bilgisi bulunamadı',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        )
      ],
    );
  }
}

class LocationWidgets extends StatelessWidget {
  final String yuklemeYeri;
  final String bosaltmaYeri;

  const LocationWidgets({
    required this.yuklemeYeri,
    required this.bosaltmaYeri,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            const Icon(Icons.location_on_outlined),
            Container(
              height: 30,
              width: 1,
              color: Colors.grey,
            ),
            const Icon(Icons.location_on_outlined),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: FittedBox(
                alignment: Alignment.topLeft,
                fit: BoxFit.scaleDown,
                child: Text(yuklemeYeri),
              ),
            ),
            SizedBox(
              width: 100,
              child: FittedBox(
                alignment: Alignment.topLeft,
                fit: BoxFit.scaleDown,
                child: Text(bosaltmaYeri),
              ),
            ),
          ],
        )
      ],
    );
  }
}
