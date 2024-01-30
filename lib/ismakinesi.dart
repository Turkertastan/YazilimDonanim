import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ismakinasi extends StatefulWidget {
  const ismakinasi({Key? key}) : super(key: key);

  @override
  State<ismakinasi> createState() => _ismakinasiState();
}

class _ismakinasiState extends State<ismakinasi> {
  final TextEditingController _controllerBaslaSaat = TextEditingController();
  final TextEditingController _controllerBitirSaat = TextEditingController();
  final TextEditingController _controllerIsyeri = TextEditingController();
  final TextEditingController _controllerKullanilacakAlan =
      TextEditingController();
  final TextEditingController _controllerAciklama = TextEditingController();
  String _aracturu = "Kepçe"; // Seçilen araç değeri
  DateTime? selectedDate = DateTime.now();

  Future<void> _yukleriKaydet({
    required String baslasaat,
    required String bitirsaat,
    required String isyer,
    required String Kullan,
    required String arac,
    required String aciklama,
    required DateTime yuklemeTarihi,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    String randomUID = generateRandomUID(); // Rastgele UID oluşturuluyor

    await FirebaseFirestore.instance.collection("ismakinesi").doc().set({
      "baslamaSaati": baslasaat,
      "bitisSaati": bitirsaat,
      "konum": isyer,
      "kullanilacakIs": Kullan,
      "hangiArac": arac,
      "ilanSahibi": user?.email,
      "tarih": Timestamp.fromDate(selectedDate ?? DateTime.now()),
      "aciklama": aciklama,
      "isİlanUID": randomUID, // Yeni özellik ekleniyor
    });
  }

  List<Map<String, dynamic>> mapismi = [];

  @override
  void initState() {
    super.initState();

    mapismi = [
      {
        "baslik": "Başlama Saati?",
        "hintText": "örn: 08.00",
        "icon": Icons.access_time,
        "controller": _controllerBaslaSaat
      },
      {
        "baslik": "Bitiş Saati?",
        "hintText": "örn: 12.00",
        "icon": Icons.access_time,
        "controller": _controllerBitirSaat
      },
      {
        "baslik": "Hangi Şehir?",
        "hintText": "örn: İstanbul-Ankara",
        "icon": Icons.location_on,
        "controller": _controllerIsyeri
      },
      {
        "baslik": "Kullanılacak Alan?",
        "hintText": "örn: Yıkım, Kum",
        "icon": Icons.work,
        "controller": _controllerKullanilacakAlan
      },
      {
        "baslik": "Açıklama Giriniz?",
        "hintText": "İlan açıklaması",
        "icon": Icons.description,
        "controller": _controllerAciklama
      },
      {
        "baslik": "İş tarihi?",
        "hintText": "örn: 2023.10.11",
        "icon": Icons.calendar_today,
      },
      {
        "baslik": "Hangi araç uygun?",
        "hintText": "örn: ",
      }
    ];
  }

  final List<String> turkiyeIlleri = [
    'Adana',
    'Adıyaman',
    'Afyonkarahisar',
    'Ağrı',
    'Amasya',
    'Ankara',
    'Antalya',
    'Artvin',
    'Aydın',
    'Balıkesir',
    'Bilecik',
    'Bingöl',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Çanakkale',
    'Çankırı',
    'Çorum',
    'Denizli',
    'Diyarbakır',
    'Düzce',
    'Edirne',
    'Elazığ',
    'Erzincan',
    'Erzurum',
    'Eskişehir',
    'Gaziantep',
    'Giresun',
    'Gümüşhane',
    'Hakkâri',
    'Hatay',
    'Iğdır',
    'Isparta',
    'İstanbul',
    'İzmir',
    'Kahramanmaraş',
    'Karabük',
    'Karaman',
    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kırıkkale',
    'Kırklareli',
    'Kırşehir',
    'Kilis',
    'Kocaeli',
    'Konya',
    'Kütahya',
    'Malatya',
    'Manisa',
    'Mardin',
    'Mersin',
    'Muğla',
    'Muş',
    'Nevşehir',
    'Niğde',
    'Ordu',
    'Osmaniye',
    'Rize',
    'Sakarya',
    'Samsun',
    'Siirt',
    'Sinop',
    'Sivas',
    'Şanlıurfa',
    'Şırnak',
    'Tekirdağ',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Uşak',
    'Van',
    'Yalova',
    'Yozgat',
    'Zonguldak',
  ];

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

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Seçilen zamanı controller'a set et
      controller.text = "${pickedTime.hour}:${pickedTime.minute}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İş Makinesi İlanı Ver"),
        backgroundColor: const Color.fromARGB(255, 146, 141, 134),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: Column(
            children: mapismi.map((Map<String, dynamic> e) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 150,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(e["baslik"]),
                          leading: Icon(e["icon"]),
                        ),
                        if (e["baslik"] == "İş tarihi?")
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
                        else if (e["baslik"] == "Hangi araç uygun?")
                          DropdownButtonFormField<String>(
                            value: _aracturu,
                            onChanged: (String? newValue) {
                              setState(() {
                                _aracturu = newValue!;
                              });
                            },
                            items: [
                              "Kepçe",
                              "Damperli Kamyon",
                              "Traktör",
                              "Ekskavatör",
                              "Forklift"
                            ].map((String arac) {
                              return DropdownMenuItem<String>(
                                value: arac,
                                child: Text(arac),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              hintText: e["hintText"],
                            ),
                          )
                        else if (e["baslik"] == "Başlama Saati?" ||
                            e["baslik"] == "Bitiş Saati?")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _selectTime(context, e["controller"]);
                                },
                                child: const Text("Saat Seç"),
                              ),
                              Text(
                                e["controller"].text,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          )
                        else if (e["baslik"] == "Hangi Şehir?")
                          DropdownButtonFormField<String>(
                            value: turkiyeIlleri.first,
                            onChanged: (String? newValue) {
                              setState(() {
                                _controllerIsyeri.text = newValue!;
                              });
                            },
                            items: turkiyeIlleri.map((String sehir) {
                              return DropdownMenuItem<String>(
                                value: sehir,
                                child: Text(sehir),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              hintText: e["hintText"],
                            ),
                          )
                        else
                          TextField(
                            controller: e["controller"],
                            decoration:
                                InputDecoration(hintText: e["hintText"]),
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
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Kaydet", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        onPressed: () async {
          if (_controllerBaslaSaat.text.isEmpty ||
              _controllerBitirSaat.text.isEmpty ||
              _controllerIsyeri.text.isEmpty ||
              _controllerKullanilacakAlan.text.isEmpty ||
              _controllerAciklama.text.isEmpty) {
            // Eksik alan uyarısı göster
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lütfen tüm alanları doldurunuz.'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            // Tüm alanlar dolu, kaydetme işlemini gerçekleştir
            final basla1 = _controllerBaslaSaat.text;
            final bitir1 = _controllerBitirSaat.text;
            final isyer1 = _controllerIsyeri.text;
            final kullan1 = _controllerKullanilacakAlan.text;
            final araci = _aracturu;
            final aciklama1 = _controllerAciklama.text;
            final yuklemeTarihi = selectedDate ?? DateTime.now();
            await _yukleriKaydet(
              baslasaat: basla1,
              bitirsaat: bitir1,
              isyer: isyer1,
              Kullan: kullan1,
              arac: araci,
              yuklemeTarihi: yuklemeTarihi,
              aciklama: aciklama1,
            );
          }
        },
        icon: const Icon(
          Icons.save,
          color: Colors.black,
        ),
      ),
    );
  }

  String generateRandomUID() {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const length = 20; // UID uzunluğu
    final random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }
}
