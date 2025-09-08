import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happy_chat_app/src/core/constants/app_images.dart';
import 'package:happy_chat_app/src/core/constants/app_strings.dart';
import 'package:happy_chat_app/src/core/helper/context_extension.dart';
import 'package:happy_chat_app/src/view/pages/verify_page.dart';
import '../../view_model/auth/auth_cubit.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final key = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final focusNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen:
          (prev, curr) =>
              prev.errorMessage != curr.errorMessage ||
              prev.phone != curr.phone ||
              prev.isLoading != curr.isLoading,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }

        if (state.phone != null &&
            !state.isLoading &&
            state.errorMessage == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => VerifyPage(phone: state.phone!),
                ),
              );
            }
          });
        }
      },

      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return BaseWidget(
          hasAppBar: false,
          body: Form(
            key: key,
            child: Column(
              spacing: 16,
              children: [
                SizedBox(height: context.screenHeight / 10),
                Text(
                  AppStrings.appName,
                  style: context.textTheme.titleLarge?.copyWith(fontSize: 40),
                ),
                const SizedBox(height: 24),
                Text(
                  'برای ثبت نام شماره تلفن خود را وارد نمایید.',
                  style: context.textTheme.bodySmall,
                ),
                CustomTextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  label: 'شماره تلفن خود را وارد نمایید',
                  focusNotifier: focusNotifier,
                  validator: (phone) {
                    if (phone == null ||
                        phone.length != 11 ||
                        !phone.startsWith('09')) {
                      return 'به نظر می آید شماره تلفن معتبری وارد نکرده اید، مجدداً تلاش کنید';
                    }
                    return null;
                  },
                  prefix: ValueListenableBuilder<bool>(
                    valueListenable: focusNotifier,
                    builder: (context, hasFocus, _) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsetsDirectional.only(end: 8),
                              height: 35,
                              width: 2,
                              color:
                                  hasFocus
                                      ? context.colorSchema.outlineVariant
                                      : context.colorSchema.outline,
                            ),
                            SvgPicture.asset(AppImages.flag),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          fab: CustomButton(
            title: state.isLoading ? "در حال ارسال..." : "ثبت نام",
            isLoading: state.isLoading,
            onPressed: () {
              if (!key.currentState!.validate()) return;
              final phone = _phoneCtrl.text.trim();
              context.read<AuthCubit>().sendOtp(phone);
            },
          ),
        );
      },
    );
  }
}
