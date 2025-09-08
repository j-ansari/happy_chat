import 'package:flutter/material.dart';
import 'package:happy_chat_app/src/core/helper/context_extension.dart';
import '../../core/helper/custom_regex_handler.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final Color? borderColor;
  final Color? bgColor;
  final int? maxLength;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Widget? prefix;
  final ValueNotifier<bool>? focusNotifier;
  final String? Function(String?)? validator;
  final double? padding;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.borderColor,
    this.bgColor,
    this.maxLength,
    this.keyboardType,
    this.onChanged,
    this.prefix,
    this.focusNotifier,
    this.validator,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final double leftPadding = prefix != null ? 48 : 12;

    return Stack(
      children: [
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLength: maxLength,
          cursorColor: context.colorSchema.outlineVariant,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            counter: const SizedBox.shrink(),
            labelText: label,
            labelStyle: context.textTheme.labelMedium,
            fillColor: bgColor ?? Colors.white,
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(leftPadding, 12, 12, 12),
            enabledBorder: _border(borderColor ?? context.colorSchema.outline),
            errorBorder: _border(context.colorSchema.error),
            focusedBorder: _border(context.colorSchema.outlineVariant),
          ),
          inputFormatters: [
            if (keyboardType == TextInputType.number ||
                keyboardType == TextInputType.phone)
              CustomRegexHandler(regex: RegExp(r'^[0-9]+$')),
          ],
        ),

        if (prefix != null)
          Positioned(left: 0, top: 0, bottom: 0, child: Center(child: prefix)),
      ],
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1),
  );
}
