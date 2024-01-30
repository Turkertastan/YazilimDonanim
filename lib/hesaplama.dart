import 'package:flutter/material.dart';

class haber extends StatefulWidget {
  const haber({super.key});

  @override
  State<haber> createState() => _haberState();
}

class _haberState extends State<haber> {
  TextEditingController nakliyeKmController = TextEditingController();
  TextEditingController nakliyeTonController = TextEditingController();
  TextEditingController nakliyeYakitFiyatiController = TextEditingController();
  double nakliyeSonuc = 0;
  double nakliyeSonucu = 0;
  TextEditingController isMakinesiYakitFiyatiController =
      TextEditingController();
  TextEditingController isMakinesiSaatController = TextEditingController();
  String isMakinesiTur = 'Kepçe'; // Default değeri
  String nakliye = 'Tır';
  double isMakinesiSonuc = 0;
  double isMakinesiSonucu = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        title: const Text("Tahmini Değerler"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: nakliyeKmController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Mesafe (km)'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nakliyeTonController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Yük Miktarı (ton)'),
                    ),
                    TextField(
                      controller: nakliyeYakitFiyatiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Ortalama Yakıt Fiyatı (TL/Litre)'),
                    ),
                    const SizedBox(height: 32),
                    DropdownButton<String>(
                      value: nakliye, 
                      onChanged: (String? newValue) {
                        setState(() {
                          nakliye = newValue!; 
                        });
                      },
                      items: <String>['Tır', 'Kırkayak', 'Kamyon']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        hesapla('nakliye');
                      },
                      child: const Text('Hesapla'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                        'Tahmini Nakliye Masrafı: $nakliyeSonuc - $nakliyeSonucu TL'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: isMakinesiTur,
                      onChanged: (String? newValue) {
                        setState(() {
                          isMakinesiTur = newValue!;
                        });
                      },
                      items: <String>[
                        'Kepçe',
                        'Ekskavatör',
                        'Damperli Kamyon',
                        'Forklift',
                        'Traktör'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: isMakinesiYakitFiyatiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Ortalama Yakıt Fiyatı (TL/Litre)'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: isMakinesiSaatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Çalışma Süresi (saat)'),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        hesapla('ismakinesi');
                      },
                      child: const Text('Hesapla'),
                    ),
                    const SizedBox(height: 16),
                    Text('Tahmini İş Makinesi Masrafı: $isMakinesiSonuc - $isMakinesiSonucu TL'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void hesapla(String tur) {
    int km = 0;
    int miktar = 0;
    int ortalamaFiyat = 0;

    if (tur == 'nakliye') {
      km = int.tryParse(nakliyeKmController.text) ?? 0;
      miktar = int.tryParse(nakliyeTonController.text) ?? 0;
      ortalamaFiyat = int.tryParse(nakliyeYakitFiyatiController.text) ?? 0;
      print("object $km $miktar $ortalamaFiyat");

      if (km > 0 && miktar > 0 && ortalamaFiyat > 0) {
        setState(() {
          if (nakliye == 'Tır') {
            nakliyeSonuc = ((km / 100) * 32 * ortalamaFiyat * 2.40);
            nakliyeSonucu = ((km / 100) * 32 * ortalamaFiyat * 3.0);
          } else if (nakliye == 'Kırkayak') {
            nakliyeSonuc = ((km / 100) * 32 * ortalamaFiyat * 2.40);
            nakliyeSonucu = ((km / 100) * 32 * ortalamaFiyat * 2.85);
          } else if (nakliye == 'Kamyon') {
            nakliyeSonuc = ((km / 100) * 32 * ortalamaFiyat * 2.15);
            nakliyeSonucu = ((km / 100) * 32 * ortalamaFiyat * 2.70);
          } else {
            print("dsjdjbs");
          }
        });
      } else {
        // Hatalı giriş durumu için kullanıcıyı uyarabilirsiniz.
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Hata'),
            content: const Text('Lütfen geçerli değerler girin.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }
    } else if (tur == 'ismakinesi') {
      double isMakinesiYakitFiyati =
          double.tryParse(isMakinesiYakitFiyatiController.text) ?? 0;
      double isMakinesiSaat =
          double.tryParse(isMakinesiSaatController.text) ?? 0;

      if (isMakinesiYakitFiyati > 0 && isMakinesiSaat > 0) {
        setState(() {
          if (isMakinesiTur == 'Kepçe') {
            isMakinesiSonuc = (isMakinesiSaat * 800);
            isMakinesiSonucu = (isMakinesiSaat * 1200);
          } else if (isMakinesiTur == 'Ekskavatör') {
            isMakinesiSonuc = (isMakinesiSaat * 1000);
            isMakinesiSonucu = (isMakinesiSaat * 1600);
          } else if (isMakinesiTur == 'Damperli Kamyon') {
            isMakinesiSonuc = (isMakinesiSaat * 700);
            isMakinesiSonucu = (isMakinesiSaat * 1200);
          } else if (isMakinesiTur == 'Forklift') {
            isMakinesiSonuc = isMakinesiSaat * 800;
            isMakinesiSonucu = (isMakinesiSaat * 1200);
          } else if (isMakinesiTur == 'Traktör') {
            isMakinesiSonuc = (isMakinesiSaat * 500);
            isMakinesiSonucu = (isMakinesiSaat * 1000);
          }
        });
      } else {
        // Hatalı giriş durumu için kullanıcıyı uyarabilirsiniz.
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Hata'),
            content: const Text('Lütfen geçerli değerler girin.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }
    }
  }
}
