import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_chat_app/src/view/pages/verify_page.dart';

import '../../view_model/auth/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              child: Text('Send OTP'),
              onPressed: () {
                final phone = _phoneCtrl.text.trim();
                context.read<AuthCubit>().sendOtp(phone);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VerifyPage(phone: phone)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
