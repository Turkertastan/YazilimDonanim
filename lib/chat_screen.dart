import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String ilanSahibiUID;
  final String ilanUID; // İlanın UID'sini taşıyan yeni parametre

  const ChatScreen({Key? key, required this.ilanSahibiUID, required this.ilanUID})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late CollectionReference _messagesCollection;
  late String myUID;

  @override
  void initState() {
    super.initState();
    _messagesCollection = FirebaseFirestore.instance.collection('messages');
    myUID = FirebaseAuth.instance.currentUser?.uid ?? "";

    print("widget.ilanSahibiUID: ${widget.ilanSahibiUID}");
    print("myUID: $myUID");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade600,
        title: const Text("Sohbet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _messagesCollection
                    .where('ilanUID', isEqualTo: widget.ilanUID) // İlanın UID'si
                    .where('sender', whereIn: [myUID, widget.ilanSahibiUID])
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var messages = snapshot.data!.docs;

                  List<Widget> messageWidgets = [];
                  for (var message in messages) {
                    var messageText = message['message'];
                    var messageSender = message['sender'];
                    var timestampField = message['timestamp'];
                    var messageTimestamp = timestampField != null
                        ? (timestampField as Timestamp).toDate()
                        : DateTime.now();

                    var isMe = messageSender == myUID;
                    var messageWidget = _buildMessage(
                      messageText,
                      isMe,
                      messageTimestamp,
                    );
                    messageWidgets.add(messageWidget);
                  }

                  return ListView(
                    reverse: false,
                    children: messageWidgets,
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(String message, bool isMe, DateTime timestamp) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Align(
        alignment: isMe ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 8.0 : 0.0),
              topRight: Radius.circular(isMe ? 0.0 : 8.0),
              bottomLeft: const Radius.circular(8.0),
              bottomRight: const Radius.circular(8.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
              Text(
                _formatTimestamp(timestamp),
                style: TextStyle(
                  color: isMe
                      ? Colors.white.withOpacity(0.6)
                      : Colors.black.withOpacity(0.6),
                  fontSize: 10.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute}';
  }

  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Mesajınızı yazın...",
                contentPadding: const EdgeInsets.all(12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              _sendMessage(_messageController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) async {
    await _messagesCollection.add({
      'message': message,
      'sender': FirebaseAuth.instance.currentUser?.uid,
      'ilanSahibiUID': widget.ilanSahibiUID,
      'ilanUID': widget.ilanUID, // İlanın UID'si
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }
}
