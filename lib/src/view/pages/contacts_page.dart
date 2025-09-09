import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_chat_app/src/core/helper/context_extension.dart';
import 'package:happy_chat_app/src/view_model/change_theme.dart';
import '../../core/constants/app_strings.dart';
import '../../core/helper/prefs.dart';
import '../../core/sl.dart';
import '../../data/repo/chat_repo.dart';
import '../../view_model/auth/auth_cubit.dart';
import '../../view_model/chat/chat_cubit.dart';
import '../../view_model/contacts/contacts_cubit.dart';
import '../widgets/widgets.dart';
import 'chat_page.dart';
import 'login_page.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ContactsCubit>();
    cubit.load();
    return BaseWidget(
      hasSearch: true,
      hasAvatar: true,
      body: BlocBuilder<ContactsCubit, List>(
        builder: (context, contacts) {
          return ListView.separated(
            itemCount: contacts.length,
            separatorBuilder:
                (c, _) =>
                    Divider(thickness: 1, color: context.colorSchema.outline),
            itemBuilder: (c, i) {
              final contact = contacts[i];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getRandomColor(),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(contact.name, style: context.textTheme.titleMedium),
                    Text(
                      AppStrings.never,
                      style: context.textTheme.labelMedium,
                    ),
                  ],
                ),
                subtitle: Text(
                  AppStrings.notRegisteredMessage,
                  style: context.textTheme.bodySmall,
                ),
                onTap: () async {
                  final token = Preferences.getString(PrefsKey.token);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (c) => BlocProvider(
                            create: (c) => ChatCubit(getIt<ChatRepo>(), token!),
                            child: ChatPage(contact: contact),
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      fab: Row(
        children: [
          CustomButton(
            title: AppStrings.exit,
            width: 100,
            onPressed: () async {
              await context.read<AuthCubit>().logout().then(
                (_) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (c) => LoginPage()),
                  (_) => false,
                ),
              );
            },
          ),
          button(context),
        ],
      ),
    );
  }

  Widget button(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;
        final c = context.read<ThemeCubit>();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 120,
          height: 50,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.red,
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment:
                    isDark ? Alignment.centerLeft : Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => c.toggle(),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      isDark ? Icons.nightlight_round : Icons.wb_sunny,
                      color: isDark ? Colors.deepPurple : Colors.orange,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
