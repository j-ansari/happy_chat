import 'package:flutter/material.dart';
import 'package:happy_chat_app/src/core/helper/context_extension.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool isLoading;
  final bool isDisable;
  final double width;
  final double height;
  final double borderRadius;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading = false,
    this.isDisable = false,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 12,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading || isDisable ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        maximumSize: Size(width, height),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor:
            isDisable || isLoading
                ? context.colorSchema.onSurface
                : context.colorSchema.onPrimary,
      ),
      child:
          icon == null
              ? handleTitle(context)
              : Row(
                children: [
                  handleTitle(context),
                  const SizedBox(width: 4),
                  if (icon != null) Icon(icon),
                ],
              ),
    );
  }

  Widget handleTitle(BuildContext context) {
    return !isLoading
        ? Text(title, style: context.textTheme.labelLarge)
        : const CircularProgressIndicator(color: Colors.white);
  }
}
