import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class KullaniciBilgileri extends StatefulWidget {
  const KullaniciBilgileri({Key? key}) : super(key: key);

  @override
  State<KullaniciBilgileri> createState() => _KullaniciBilgileriState();
}

class _KullaniciBilgileriState extends State<KullaniciBilgileri> {
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController isTelefonController = TextEditingController();
  final TextEditingController adresController = TextEditingController();
  final TextEditingController gecmisController = TextEditingController();

  late User? _user;
  List<String> selectedOptions = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade600,
        title: const Text("Bilgiler"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 20),
              UserInfoTextField(
                label: "Telefon Numarası",
                controller: telefonController,
                maxLength: 11,
                inputType: TextInputType.phone,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              UserInfoTextField(
                label: "İş Telefonu",
                controller: isTelefonController,
                maxLength: 11,
                inputType: TextInputType.phone,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 10),
              UserInfoTextField(
                label: "Adres",
                controller: adresController,
                maxLength: 50,
                inputType: TextInputType.streetAddress,
              ),
              const SizedBox(height: 10),
              UserInfoTextField(
                label: "Kullanıcı Özgeçmişi",
                controller: gecmisController,
                maxLength: null,
                inputType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              CheckboxOption(
                text: "Nakliyeci",
                isSelected: selectedOptions.contains("Nakliyeci"),
                onChanged: (bool? value) {
                  _updateSelectedOptions("Nakliyeci", value ?? false);
                },
              ),
              CheckboxOption(
                text: "Yük veren",
                isSelected: selectedOptions.contains("Yük veren"),
                onChanged: (bool? value) {
                  _updateSelectedOptions("Yük veren", value ?? false);
                },
              ),
              CheckboxOption(
                text: "İş makinesi",
                isSelected: selectedOptions.contains("İş makinesi"),
                onChanged: (bool? value) {
                  _updateSelectedOptions("İş makinesi", value ?? false);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _kullaniciBilgileriniKaydet(),
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _kullaniciBilgileriniKaydet() {
    if (_user != null) {
      String uid = _user!.uid;

      FirebaseFirestore.instance.collection('kullanicilar').doc(uid).update({
        'number': telefonController.text,
        'istelefon': isTelefonController.text,
        'adres': adresController.text,
        'gecmis': gecmisController.text,
        'isdurumu': selectedOptions,
      });
    }
  }

  void _updateSelectedOptions(String option, bool value) {
    setState(() {
      if (value) {
        // Eğer seçenek zaten seçiliyse, kaldır; değilse ekle
        if (selectedOptions.contains(option)) {
          selectedOptions.remove(option);
        } else {
          selectedOptions.add(option);
        }
      }
    });
  }
}

class UserInfoTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int? maxLength;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatter;

  const UserInfoTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.maxLength,
    required this.inputType,
    this.inputFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      keyboardType: inputType,
      maxLength: maxLength,
      inputFormatters: inputFormatter,
    );
  }
}

class CheckboxOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function(bool?) onChanged;

  const CheckboxOption({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(text),
      value: isSelected,
      onChanged: (bool? value) {
        if (value != null && value) {
          onChanged(value);
        } else {
          // Eğer harf girilirse hata mesajını göster
          _showErrorSnackBar(context, "Sadece rakam girebilirsiniz.");
        }
      },
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
