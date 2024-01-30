import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DestekIletisim extends StatefulWidget {
  const DestekIletisim({Key? key}) : super(key: key);

  @override
  State<DestekIletisim> createState() => _DestekIletisimState();
}

class _DestekIletisimState extends State<DestekIletisim> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: const Text('Destek ve iletişim'),
      ),
      body: DestekForm(),
    );
  }
}

class DestekForm extends StatelessWidget {
  final TextEditingController _feedbackController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DestekForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Destek ve iletişim formu',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Mesajınız',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String feedback = _feedbackController.text;

                // Kullanıcının kimliğini al
                User? user = _auth.currentUser;

                if (user != null) {
                  // Firestore veritabanına geri bildirimi ekleyin
                  await FirebaseFirestore.instance.collection('feedback').add({
                    'userId': user.uid, // Kullanıcının kimliğini kaydedin
                    'message': feedback,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  // Geri bildirimi gönderdikten sonra kullanıcıya mesaj göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Geri bildiriminiz alındı. Teşekkür ederiz!'),
                    ),
                  );
                } else {
                  // Kullanıcı oturumu açık değilse uyarı göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen oturum açın.'),
                    ),
                  );
                }
              },
              child: const Text('Gönder'),
            ),
            const SizedBox(height: 16),
            const CardList(),
          ],
        ),
      ),
    );
  }
}

class CardList extends StatelessWidget {
  const CardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        DelayedCard(title: "Bilgi almak için", delay: 1.5),
        DelayedCard(title: "turkertastan98@gmail.com", delay: 1.6),
        DelayedCard(title: "Adresine mail atabilirsiniz.", delay: 1.7),
      ],
    );
  }
}

class DelayedCard extends StatefulWidget {
  final double delay;
  final String title;

  const DelayedCard({Key? key, required this.delay, required this.title})
      : super(key: key);

  @override
  _DelayedCardState createState() => _DelayedCardState();
}

class _DelayedCardState extends State<DelayedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(seconds: widget.delay.toInt()), () {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListTile(
            title: Text(widget.title),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
