import 'dart:math';

import 'package:flutter/material.dart';

class CrackPassApp extends StatefulWidget {
  const CrackPassApp({super.key});

  @override
  State<CrackPassApp> createState() => _CrackPassAppState();
}

class _CrackPassAppState extends State<CrackPassApp> {
  final Random rand = Random();
  final TextEditingController inputController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String guessedPassword = '';
  int step = 0;
  bool isCracking = false;

  @override
  void dispose() {
    inputController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _restartApp() {
    setState(() {
      inputController.text = '';
      passwordController.text = '';
      guessedPassword = '';
      step = 0;
      isCracking = false;
    });
  }

  void crackPassword() {
    setState(() {
      isCracking = true;
      final input = inputController.text.split('');
      final password = passwordController.text;

      Future.delayed(const Duration(milliseconds: 100), () {
        while (password != guessedPassword) {
          step++;
          guessedPassword = _generateRandomPassword(input, password.length);
        }
        setState(() {
          isCracking = false;
        });
      });
    });
  }

  String _generateRandomPassword(List<String> input, int length) {
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.write(input[rand.nextInt(input.length)]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Cracker'),
        actions: [
          IconButton(
            onPressed: _restartApp,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: inputController,
              decoration: const InputDecoration(
                labelText: 'Characters to try',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some characters';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password to crack',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return value;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isCracking ? null : crackPassword,
              child: const Text('Crack Password'),
            ),
            const SizedBox(height: 16),
            if (isCracking)
              const CircularProgressIndicator()
            else
              Text('Trying password: $guessedPassword'),
            Text(
              'Your password is ${passwordController.text} and it was cracked in $step steps.',
            ),
          ],
        ),
      ),
    );
  }
}
