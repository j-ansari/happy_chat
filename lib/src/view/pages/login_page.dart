import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happy_chat_app/src/core/helper/context_extension.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_strings.dart';
import '../../core/helper/convert_number.dart';
import '../../core/helper/custom_regex_handler.dart';
import '../../view_model/auth/auth_cubit.dart';
import '../widgets/widgets.dart';
import 'verify_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final key = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final focusNotifier = ValueNotifier<bool>(false);
  final focusNode = FocusNode();
  late AuthCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<AuthCubit>();
    focusNode.addListener(() => focusNotifier.value = focusNode.hasFocus);
  }

  @override
  void dispose() {
    phoneController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.isSuccess &&
            state.phone != null &&
            !state.isLoading &&
            state.sendOtpError == null) {
          final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
          if (!isCurrent) return;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VerifyPage(phone: state.phone!),
              ),
            );
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
                  AppStrings.registerTitle,
                  style: context.textTheme.bodySmall,
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: ValueListenableBuilder(
                    valueListenable: focusNotifier,
                    builder: (context, hasFocus, _) {
                      return TextFormField(
                        style: context.textTheme.bodyMedium,
                        textDirection: TextDirection.rtl,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        focusNode: focusNode,
                        onChanged:
                            (v) => context.read<AuthCubit>().setPhoneNumber(v),
                        validator: (ph) {
                          final phone = ConvertNumber.normalizeDigits(ph!);
                          if (phone.length != 11 || !phone.startsWith('09')) {
                            return AppStrings.invalidNumber;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          counter: const SizedBox.shrink(),
                          alignLabelWithHint: true,
                          label: Text(
                            AppStrings.inputNumber,
                            style: context.textTheme.labelMedium,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: _border(context.colorSchema.outline),
                          errorBorder: _border(context.colorSchema.error),
                          focusedBorder: _border(
                            context.colorSchema.outlineVariant,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(AppImages.flag),
                                Container(
                                  margin: const EdgeInsetsDirectional.only(
                                    start: 8,
                                  ),
                                  height: 35,
                                  width: 2,
                                  color:
                                      hasFocus
                                          ? context.colorSchema.outlineVariant
                                          : context.colorSchema.outline,
                                ),
                              ],
                            ),
                          ),
                        ),
                        inputFormatters: [
                          CustomRegexHandler(
                            regex: RegExp(
                              r'^[0-9\u06F0-\u06F9\u0660-\u0669]+$',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (state.sendOtpError != null)
                  Text(
                    state.sendOtpError!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorSchema.error,
                    ),
                  ),
              ],
            ),
          ),
          fab: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return CustomButton(
                title: AppStrings.register,
                isLoading: state.isLoading,
                isDisable: !state.isDisabled,
                onPressed: () {
                  if (!key.currentState!.validate()) return;
                  final phone = phoneController.text.trim();
                  context.read<AuthCubit>().sendOtp(phone);
                },
              );
            },
          ),
        );
      },
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1),
  );
}
