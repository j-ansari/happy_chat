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
  final Color? color;

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
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isLoading || isDisable ? null : onPressed,
      minWidth: width,
      height: height,
      color:
          isDisable
              ? (color != null
                  ? color?.withOpacity(0.2)
                  : context.colorSchema.primary.withOpacity(0.2))
              : color ?? context.colorSchema.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 0,
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
        ? Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(color: Colors.white),
        )
        : const CircularProgressIndicator(color: Colors.white);
  }
}
