import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:auth_service/auth_service.dart';
import 'package:flutter/material.dart';

enum PostState {
  POST_YET,
  POSTED,
}

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _weightController = TextEditingController();
  PostState _state = PostState.POST_YET;

  Widget _content() {
    if (_state == PostState.POSTED) {
      return _contentPosted();
    } else
      return _contentPostYet();
  }

  Widget _contentPosted() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "本日の入力は済みました",
          style: TextStyle(fontSize: 30),
        ),
      ],
    );
  }

  Widget _contentPostYet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 50.0),
        const Text(
          "1日1回",
          style: TextStyle(fontSize: 30),
        ),
        const SizedBox(height: 20.0),
        const Text(
          "自分の体重を計測して保存しましょう!",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 50.0),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: TextField(
              controller: _weightController,
              decoration: const InputDecoration(hintText: 'Weight: XX.X (kg)')),
        ),
        const SizedBox(height: 50.0),
        ElevatedButton(
          onPressed: () async {
            DateTime now = DateTime.now();

            await FirebaseFirestore.instance
                .collection('weight')
                .doc("${FirebaseAuth.instance.currentUser?.email}")
                .collection("${now.year}年${now.month}月")
                .add({
              'weight': double.parse(_weightController.text),
              'occured_at': DateFormat('yyyy-MM-dd').format(now)
            });
            setState(() {
              _state = PostState.POSTED;
            });
          },
          child: const Text('Save'),
        ),
        const SizedBox(height: 50.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _content());
  }
}
