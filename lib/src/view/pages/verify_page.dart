import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_chat_app/src/core/helper/context_extension.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pinput/pinput.dart';
import '../../core/constants/app_strings.dart';
import '../../core/helper/convert_number.dart';
import '../../view_model/auth/auth_cubit.dart';
import '../widgets/widgets.dart';
import 'contacts_page.dart';

class VerifyPage extends StatefulWidget {
  final String phone;

  const VerifyPage({super.key, required this.phone});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final key = GlobalKey<FormState>();
  late OTPInteractor oTPInteractor;
  late OTPTextEditController otpController;

  @override
  void initState() {
    super.initState();
    _initOtpInteractor();
    otpController = OTPTextEditController(
      codeLength: 4,
      onCodeReceive: (code) {},
      otpInteractor: oTPInteractor,
    )..startListenUserConsent((code) {
      if (code != null) {
        otpController.text = code;
        _verify(code);
      }
      return code ?? "";
    });
  }

  @override
  void dispose() {
    oTPInteractor.stopListenForCode();
    otpController.dispose();
    super.dispose();
  }

  Future<void> _initOtpInteractor() async {
    oTPInteractor = OTPInteractor();
    await oTPInteractor.getAppSignature();
  }

  void _verify(String c) {
    final code = ConvertNumber.normalizeDigits(c);
    if (code.length != 4) return;
    final otp = int.tryParse(code) ?? 0;
    context.read<AuthCubit>().verifyOtp(widget.phone, otp);
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isSuccess && state.token != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ContactsPage()),
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          return Column(
            spacing: 16,
            children: [
              SizedBox(height: context.screenHeight / 10),
              Text(
                AppStrings.appName,
                style: context.textTheme.titleLarge?.copyWith(fontSize: 40),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.inputCodeTitle,
                style: context.textTheme.bodySmall,
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  controller: otpController,
                  length: 4,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: PinTheme(
                    height: 60,
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: context.colorSchema.outline,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: context.colorSchema.secondary,
                    ),
                  ),
                  onChanged: (code) {
                    if (code.length == 4) {
                      _verify(code);
                    }
                  },
                ),
              ),
              if (state.errorMessage != null)
                Text(
                  state.errorMessage!,
                  style: TextStyle(color: context.colorSchema.error),
                ),
              if (state.timer > 0)
                Text(
                  "ارسال مجدد کد تا ${state.timer} ثانیه دیگر",
                  style: context.textTheme.bodyMedium,
                ),
              if (state.canResend)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed:
                          state.isLoading
                              ? null
                              : () {
                                context.read<AuthCubit>().sendOtp(widget.phone);
                              },
                      child: const Text(
                        AppStrings.resendCode,
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                    if (state.isLoading) const CircularProgressIndicator(),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
