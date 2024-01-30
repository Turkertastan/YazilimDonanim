import 'package:flutter/material.dart';
import 'package:my_flutter_app/tasiyicilan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_flutter_app/yeni_navigation.dart';
import 'dart:math';

class yukveren extends StatefulWidget {
  const yukveren({super.key});

  @override
  State<yukveren> createState() => _yukverenState();
}

class _yukverenState extends State<yukveren> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerYukNe = TextEditingController();
  final TextEditingController _controllerAciklama = TextEditingController();

  String _selectedTonaj = "1"; // Default tonaj seçimi
  String _selectedYukYeri = "Adana"; // Default yük yeri seçimi
  String _selectedBosYeri = "Adana"; // Default boşaltma yeri seçimi
  String _aracTuru = "Tır";
  DateTime? selectedDate = DateTime.now();

  Future<bool> _yukleriKaydet({
    required String yuk,
    required String tonaj,
    required String yukleme,
    required String bosaltma,
    required String arac,
    required DateTime yuklemeTarihi,
    required String aciklama,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
  String randomUID = generateRandomUID(); // Rastgele UID oluşturuluyor
  await FirebaseFirestore.instance.collection("ilanlar").doc().set({
    "yükü": yuk,
    "yüktonajı": tonaj,
    "yüklemeyeri": yukleme,
    "bosaltmayeri": bosaltma,
    "hangiarac": arac,
    "ilansahibi": user?.email,
    "yuklemeTarihi": Timestamp.fromDate(selectedDate ?? DateTime.now()),
    "Açıklama": aciklama,
    "ilanSahibiUID": user!.uid,
    "ilanUID": randomUID, // Yeni özellik ekleniyor
  });
  return true;
} catch (e) {
  return false;
}

  }

  List<Map<String, dynamic>> mapItems = [];
  final List<String> turkiyeIlleri = [
    'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Amasya', 'Ankara',
    'Antalya', 'Artvin', 'Aydın', 'Balıkesir', 'Bilecik', 'Bingöl', 'Bitlis',
    'Bolu', 'Burdur', 'Bursa', 'Çanakkale', 'Çankırı', 'Çorum', 'Denizli',
    'Diyarbakır', 'Düzce', 'Edirne', 'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir',
    'Gaziantep', 'Giresun', 'Gümüşhane', 'Hakkâri', 'Hatay', 'Iğdır', 'Isparta',
    'İstanbul', 'İzmir', 'Kahramanmaraş', 'Karabük', 'Karaman', 'Kars', 'Kastamonu',
    'Kayseri', 'Kırıkkale', 'Kırklareli', 'Kırşehir', 'Kilis', 'Kocaeli', 'Konya',
    'Kütahya', 'Malatya', 'Manisa', 'Mardin', 'Mersin', 'Muğla', 'Muş', 'Nevşehir',
    'Niğde', 'Ordu', 'Osmaniye', 'Rize', 'Sakarya', 'Samsun', 'Siirt', 'Sinop',
    'Sivas', 'Şanlıurfa', 'Şırnak', 'Tekirdağ', 'Tokat', 'Trabzon', 'Tunceli',
    'Uşak', 'Van', 'Yalova', 'Yozgat', 'Zonguldak',
  ];

  @override
  void initState() {
    super.initState();

    mapItems = [
      {
        "baslik": "Yükünüz nedir?",
        "hintText": "örn: ev esyası, hurda",
        "icon": Icons.home,
        "controller": _controllerYukNe,
      },
      {
        "baslik": "Yükünüz kaç ton?",
        "hintText": "Seçiniz",
        "icon": Icons.filter_tilt_shift,
      },
      {
        "baslik": "Yükleme yeri?",
        "hintText": "Seçiniz",
        "icon": Icons.location_on,
      },
      {
        "baslik": "Boşaltma yeri?",
        "hintText": "Seçiniz",
        "icon": Icons.location_on,
      },
      {
        "baslik": "Yükleme tarihi?",
        "hintText": "örn: 2023.10.11",
        "icon": Icons.calendar_today,
      },
      {
        "baslik": "Hangi araç uygun?",
        "hintText": "örn: Tır, Kırkayak, Kamyon",
      },
      {
        "baslik": "Açıklama Giriniz?",
        "hintText": "İlan açıklaması",
        "icon": Icons.location_on,
        "controller": _controllerAciklama
      },
    ];
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      pickedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);

      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nakliye İlanı Ver"),
        backgroundColor: const Color.fromARGB(255, 146, 141, 134),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: mapItems.map((Map<String, dynamic> e) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 150,
                    child: Card(
                      elevation: 5, // Gölge
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Köşe ovalleştirme
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(e["baslik"]),
                            leading: Icon(e["icon"]),
                          ),
                          if (e["baslik"] == "Yükleme tarihi?")
                            GestureDetector(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${selectedDate?.year}.${selectedDate?.month}.${selectedDate?.day}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            )
                          else if (e["baslik"] == "Yükünüz kaç ton?")
                            DropdownButtonFormField<String>(
                              value: _selectedTonaj,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedTonaj = newValue!;
                                });
                              },
                              items: List.generate(50, (index) {
                                return DropdownMenuItem<String>(
                                  value: (index + 1).toString(),
                                  child: Text((index + 1).toString()),
                                );
                              }),
                              decoration: InputDecoration(
                                hintText: e["hintText"],
                              ),
                            )
                          else if (e["baslik"] == "Yükleme yeri?" || e["baslik"] == "Boşaltma yeri?")
                            DropdownButtonFormField<String>(
                              value: e["baslik"] == "Yükleme yeri?" ? _selectedYukYeri : _selectedBosYeri,
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (e["baslik"] == "Yükleme yeri?") {
                                    _selectedYukYeri = newValue!;
                                  } else {
                                    _selectedBosYeri = newValue!;
                                  }
                                });
                              },
                              items: turkiyeIlleri
                                  .map((il) => DropdownMenuItem<String>(
                                        value: il,
                                        child: Text(il),
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                hintText: e["hintText"],
                              ),
                            )
                          else if (e["baslik"] == "Hangi araç uygun?")
                            DropdownButtonFormField<String>(
                              value: _aracTuru,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _aracTuru = newValue!;
                                });
                              },
                              items: ["Tır", "Kırkayak", "Kamyon", "Pikap"]
                                  .map((String arac) {
                                return DropdownMenuItem<String>(
                                  value: arac,
                                  child: Text(arac),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                hintText: e["hintText"],
                              ),
                            )
                          else
                            TextFormField(
                              controller: e["controller"],
                              decoration: InputDecoration(
                                hintText: e["hintText"],
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Lütfen bu alanı doldurunuz';
                                }
                                return null;
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "Kaydet",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            final yuk = _controllerYukNe.text;
            final tonaj = _selectedTonaj;
            final yukYeri = _selectedYukYeri;
            final bosYeri = _selectedBosYeri;
            final arac = _aracTuru;
            final yuklemeTarihi = selectedDate ?? DateTime.now();
            final aciklama1 = _controllerAciklama.text;

            final kaydedildiMi = await _yukleriKaydet(
              yuk: yuk,
              tonaj: tonaj,
              yukleme: yukYeri,
              bosaltma: bosYeri,
              arac: arac,
              yuklemeTarihi: yuklemeTarihi,
              aciklama: aciklama1,
            );

            if (kaydedildiMi) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("İlan başarıyla kaydedildi.")),
              );

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Builder(
                    builder: (BuildContext context) {
                      return const newNavigationbar();
                    },
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("İlan kaydedilemedi :(")),
              );
            }
          }
        },
        icon: const Icon(
          Icons.save,
          color: Colors.black,
        ),
      ),
    );
  }String generateRandomUID() {
  const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  const length = 20; // UID uzunluğu
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}
}
