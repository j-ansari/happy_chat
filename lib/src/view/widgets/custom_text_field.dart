import 'package:flutter/material.dart';
import 'package:happy_chat_app/src/core/helper/context_extension.dart';
import '../../core/helper/custom_regex_handler.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final Color? borderColor;
  final int? maxLength;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Widget? prefix;
  final ValueNotifier<bool>? focusNotifier;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.borderColor,
    this.maxLength,
    this.keyboardType,
    this.onChanged,
    this.prefix,
    this.focusNotifier,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      widget.focusNotifier?.value = _focusNode.hasFocus;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defColor = widget.borderColor ?? context.colorSchema.outline;
    final currentBorderColor =
        _focusNode.hasFocus ? context.colorSchema.outlineVariant : defColor;

    return Directionality(
      textDirection:
          widget.prefix == null ? TextDirection.rtl : TextDirection.ltr,
      child: TextFormField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        maxLength: widget.maxLength,
        cursorColor: context.colorSchema.outlineVariant,
        keyboardType: widget.keyboardType,
        focusNode: _focusNode,
        validator: widget.validator,
        decoration: InputDecoration(
          counter: const SizedBox.shrink(),
          border: _border(currentBorderColor),
          enabledBorder: _border(Colors.red),
          focusedBorder: _border(context.colorSchema.outlineVariant),
          prefixIcon: widget.prefix,
        ),
        inputFormatters: [
          if (widget.keyboardType == TextInputType.number ||
              widget.keyboardType == TextInputType.phone)
            CustomRegexHandler(regex: RegExp(r'^[0-9]+$')),
        ],
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1),
  );
}
