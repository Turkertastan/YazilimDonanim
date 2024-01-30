import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/kullanici_profil_incele.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.aramaIstegi}) : super(key: key);

  final String aramaIstegi;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  @override
  void initState() {
    _searchUsers();
    super.initState();
  }

  void _searchUsers() async {
    print(widget.aramaIstegi);

    // Baş harfi widget.aramaIstegi ile başlayan ve bir sonraki harften küçük olanları getir.
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('kullanicilar')
        .where('isim', isGreaterThanOrEqualTo: widget.aramaIstegi)
        .where('isim', isLessThan: '${widget.aramaIstegi}z')
        .get();

    setState(() {
      _searchResults = result.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.aramaIstegi),
        backgroundColor: Colors.grey.shade500,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> datalar = _searchResults[index].data() as Map<String, dynamic>;

            // uid bilgisini al
            String uid = datalar["uid"] ?? ""; // "uid" yerine kullanıcı belgesindeki gerçek alan adını kullanın

            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage("assets/logo.png"),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(datalar["isim"] ?? "BOŞ"),
                subtitle: Text(datalar["email"] ?? "Email yok"),

                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KullaniciProfilSayfasi(
                        kullaniciIsmi: datalar["isim"] ?? "BOŞ",
                        uid: uid,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
