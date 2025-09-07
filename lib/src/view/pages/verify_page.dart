import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/auth/auth_cubit.dart';
import 'contacts_page.dart';
import 'package:otp_autofill/otp_autofill.dart';

class VerifyPage extends StatefulWidget {
  final String phone;

  const VerifyPage({super.key, required this.phone});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  late OTPInteractor _oTPInteractor;
  late OTPTextEditController controller;

  @override
  void initState() {
    super.initState();
    initInteractor();
    controller = OTPTextEditController(
      codeLength: 4,
      onCodeReceive: (code) {},
      otpInteractor: _oTPInteractor,
    )..startListenUserConsent((code) {
      controller.text = code!;
      _verify();
      return code;
    });
    // Start listening for SMS user-consent (Android & iOS-compatible logic)
    // _otpAutoFill.listenForCode();
    // _otpAutoFill.getAppSignature().then((signature) {});
    // _otpAutoFill.code.listen((code) {
    //   if (code != null) {
    //     _pinCtrl.text = code;
    //     _verify();
    //   }
    // });
  }

  Future<void> initInteractor() async {
    _oTPInteractor = OTPInteractor();
    await _oTPInteractor.getAppSignature();
  }

  void _verify() {
    final otp = int.tryParse(controller.text.trim()) ?? 0;
    context.read<AuthCubit>().verifyOtp(widget.phone, otp).then((_) {
      final state = context.read<AuthCubit>().state;
      if (state is Authenticated) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ContactsPage()),
          (_) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _oTPInteractor.stopListenForCode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Pinput(controller: controller, length: 4),
            SizedBox(height: 12),
            ElevatedButton(onPressed: _verify, child: Text('Verify')),
          ],
        ),
      ),
    );
  }
}
