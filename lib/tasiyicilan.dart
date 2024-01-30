import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/chat_screen.dart';
import 'package:my_flutter_app/core/custom_bottom_sheet.dart';
import 'package:my_flutter_app/modeller/is_makinesi_model.dart';

class TasiyiciIlanlariView extends StatefulWidget {
  const TasiyiciIlanlariView({super.key});

  @override
  State<TasiyiciIlanlariView> createState() => _TasiyiciIlanlariViewState();
}

class _TasiyiciIlanlariViewState extends State<TasiyiciIlanlariView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> myTabs = [];
  List<Ilan> ilanlar = [];
  final List<IsMakinesiModel> _isMakinesiModeller = [];
  bool isMakinesiMi = false;

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime weekDayDate = today.add(Duration(days: i));
      String dayName = _dayName(weekDayDate.weekday);
      myTabs.add(
        Tab(
          icon: Text('${weekDayDate.day}'),
          text: dayName,
        ),
      );
    }

    _tabController = TabController(vsync: this, length: myTabs.length);
    _yuklemeIslemleriniTamamla();
  }

  Future<void> _yuklemeIslemleriniTamamla() async {
    await ilanlariGetir();
    await ismakinasiIlanlari();
    setState(() {});
  }

  String _dayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Pzt';
      case 2:
        return 'Salı';
      case 3:
        return 'Çar';
      case 4:
        return 'Per';
      case 5:
        return 'Cum';
      case 6:
        return 'Cmt';
      case 7:
        return 'Paz';
      default:
        return '';
    }
  }

  Future<void> ilanlariGetir() async {
    try {
      print("İlanlar yükleniyor...");
      final veriCekme =
          await FirebaseFirestore.instance.collection("ilanlar").get();
      final dokumanlar = veriCekme.docs;

      for (var element in dokumanlar) {
        final data = element.data();
        final tarihCekme = data["yuklemeTarihi"];

        // Eğer yuklemeTarihi null değilse devam et, aksi takdirde atla
        if (tarihCekme != null) {
          final DateTime tarih = tarihCekme.toDate();

          final aciklama = data["Açıklama"] as String? ?? "Açıklama yok";

          ilanlar.add(Ilan(
            yuk: data["yükü"] ?? "",
            tonaj: data["yüktonajı"] ?? "",
            yuklemeYeri: data["yüklemeyeri"] ?? "",
            bosaltmaYeri: data["bosaltmayeri"] ?? "",
            arac: data["hangiarac"] ?? "",
            yuklemeTarihi: tarih,
            ilanSahibiUID: data["ilanSahibiUID"] ?? "",
            aciklama: aciklama,
            ilanUID: element.id
          ));
        }
      }

      print("İlanlar yüklendi!");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> ismakinasiIlanlari() async {
    try {
      final response =
          await FirebaseFirestore.instance.collection("ismakinesi").get();

      final listData = response.docs;

      for (var element in listData) {
        final data = IsMakinesiModel.fromJson(element.data());
        _isMakinesiModeller.add(data);
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: const Text('Haftalık İlanlar'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 50),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: myTabs,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        isMakinesiMi = false;
                      });
                    },
                    child: Text(
                      "Nakliye",
                      style: TextStyle(
                          color: isMakinesiMi ? Colors.grey : Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isMakinesiMi = true;
                      });
                    },
                    child: Text(
                      "İş Makinesi",
                      style: TextStyle(
                          color: isMakinesiMi ? Colors.white : Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          return _buildTabContent(tab);
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(Tab tab) {
    final gunKontrol = [];
    final List<IsMakinesiModel> isMakinesi = [];

    if (isMakinesiMi) {
      for (var element in _isMakinesiModeller) {
        final int getDate = element.tarih!.toDate().day;
        if (tab.icon.toString().contains(getDate.toString())) {
          isMakinesi.add(element);
        }
      }
    } else {
      for (var element in ilanlar) {
        final int getDate = element.yuklemeTarihi.day;
        if (tab.icon.toString().contains(getDate.toString())) {
          gunKontrol.add(element);
        }
      }
    }

    return (gunKontrol.isEmpty && isMakinesi.isEmpty)
        ? const IlanYokWidget()
        : ListView.builder(
            itemCount: isMakinesiMi ? isMakinesi.length : gunKontrol.length,
            itemBuilder: (context, index) {
              if (isMakinesiMi) {
                return IsMakinesiCard(makineIlan: isMakinesi[index]);
              } else {
                return TasiyiciCard(ilan: gunKontrol[index]);
              }
            },
          );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// ... Diğer widget sınıfları ...

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
  final String ilanUID; // Eklenen alan
  final String yuk;
  final String tonaj;
  final String yuklemeYeri;
  final String bosaltmaYeri;
  final String arac;
  final DateTime yuklemeTarihi;
  final String aciklama;
  final String ilanSahibiUID;

  Ilan({
    required this.ilanUID, // Güncellenen kısım
    required this.yuk,
    required this.tonaj,
    required this.yuklemeYeri,
    required this.bosaltmaYeri,
    required this.arac,
    required this.yuklemeTarihi,
    required this.ilanSahibiUID,
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 10,
        color: Colors.grey.shade600,
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
                      _ilanTarihi()
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
                            child: Column(
                              children: [
                                Text(ilan.aciklama),
                                ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            ilanSahibiUID: ilan.ilanSahibiUID,
                                            ilanUID: ilan
                                                .ilanUID, // ilanUID'yi sağladık
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.message),
                                    label: const Text("Mesajlaş"))
                              ],
                            ),
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
        children: [const Text("Arac Türü"), Text(ilan.arac)],
      );

  Column _tonaj() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [const Text("Tonaj"), Text(ilan.tonaj)],
    );
  }

  Widget _yukTuru() {
    String arac = ilan.arac.toLowerCase(); // Aracı küçük harfe çeviriyoruz

    // Araca göre image'yi seçiyoruz
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
        Image(height: 35, image: aracImage),
      ],
    );
  }

  Column _ilanTarihi() {
    return Column(
      children: [
        Text(
          ' ${ilan.yuklemeTarihi.day}-${ilan.yuklemeTarihi.month}-${ilan.yuklemeTarihi.year}',
          style: const TextStyle(fontSize: 16, color: Colors.black),
        )
      ],
    );
  }
}

class IsMakinesiCard extends StatelessWidget {
  final IsMakinesiModel makineIlan;

  const IsMakinesiCard({
    Key? key,
    required this.makineIlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      meraba(
                        baslaSaat: makineIlan.baslamaSaati ?? "",
                        bitirSaat: makineIlan.bitisSaati ?? "",
                      ),
                      _yukTuru(),
                      _ilanTarihi()
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
                            child: Column(
                              children: [
                                Text(makineIlan.aciklama ?? ""),
                                Text(makineIlan.aciklama ?? ""),
                              ],
                            ),
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
        children: [const Text("Arac Türü"), Text(makineIlan.hangiArac ?? "")],
      );

  Column _tonaj() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [const Text("Hangi Şehir"), Text(makineIlan.konum ?? "")],
    );
  }

  Widget _yukTuru() {
    String arac = (makineIlan.hangiArac ?? "").toLowerCase();

    AssetImage aracImage;
    if (arac.contains("Kepçe")) {
      aracImage = const AssetImage("assets/kepce.png");
    } else if (arac.contains("Damperli Kamyon")) {
      aracImage = const AssetImage("assets/damperlikamyon.png");
    } else if (arac.contains("Traktör")) {
      aracImage = const AssetImage("assets/tractor.png");
    } else if (arac.contains("Ekskavatör")) {
      aracImage = const AssetImage("assets/excavator.png");
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
          ' ${makineIlan.tarih?.toDate().day ?? 0}-${makineIlan.tarih?.toDate().month ?? 0}-${makineIlan.tarih?.toDate().year ?? 0}',
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

class meraba extends StatelessWidget {
  final String baslaSaat;
  final String bitirSaat;

  const meraba({
    required this.baslaSaat,
    required this.bitirSaat,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            const Icon(Icons.access_time),
            Container(
              height: 30,
              width: 1,
              color: Colors.grey,
            ),
            const Icon(Icons.access_time),
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
                child: Text(baslaSaat),
              ),
            ),
            SizedBox(
              width: 100,
              child: FittedBox(
                alignment: Alignment.topLeft,
                fit: BoxFit.scaleDown,
                child: Text(bitirSaat),
              ),
            ),
          ],
        )
      ],
    );
  }
}
