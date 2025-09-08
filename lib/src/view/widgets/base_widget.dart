import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happy_chat_app/src/core/constants/app_images.dart';
import 'package:happy_chat_app/src/core/helper/context_extension.dart';

class BaseWidget extends StatelessWidget {
  final Widget body;
  final Widget? fab;
  final bool hasAppBar;
  final bool hasSearch;
  final bool hasAvatar;
  final String? appBarTitle;

  const BaseWidget({
    super.key,
    required this.body,
    this.fab,
    this.hasAppBar = true,
    this.hasSearch = false,
    this.hasAvatar = false,
    this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            hasAppBar
                ? AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  title: Row(
                    children: [
                      hasSearch
                          ? GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.search),
                          )
                          : GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.colorSchema.outline,
                              ),
                              child: SvgPicture.asset(AppImages.backIcon),
                            ),
                          ),
                      const SizedBox(width: 16),
                      if (!hasSearch)
                        Text('بازگشت', style: context.textTheme.bodyMedium),
                      const Spacer(),
                      if (appBarTitle != null)
                        Text(
                          appBarTitle ?? '',
                          style: context.textTheme.titleMedium,
                        ),
                      const Spacer(),
                      if (hasAvatar)
                        Icon(
                          Icons.person_pin,
                          size: 44,
                          color: Colors.grey[600],
                        )
                      else
                        const SizedBox(width: 44),
                    ],
                  ),
                )
                : null,
        body: Container(
          padding: const EdgeInsets.all(16),
          width: context.screenWidth,
          height: context.screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Colors.white, Colors.white, Color(0xfffcedea)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.2, 1],
            ),
          ),
          child: body,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: fab,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
