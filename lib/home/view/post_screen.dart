import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  PostScreen({Key? key}) : super(key: key);
  final TextEditingController _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        _PostWeight(weightController: _weightController),
        const SizedBox(height: 50.0),
        _SubmitButton(
          weight: _weightController,
        ),
        const SizedBox(height: 50.0),
      ],
    );
  }
}

class _PostWeight extends StatelessWidget {
  const _PostWeight({
    Key? key,
    required this.weightController,
  }) : super(key: key);

  final TextEditingController weightController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
          controller: weightController,
          decoration: const InputDecoration(hintText: 'Weight: XX.X (kg)')),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
    required this.weight,
  }) : super(key: key);

  final TextEditingController weight;
  // final AuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {},
      child: const Text('Save'),
    );
  }
}
