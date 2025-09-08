import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_chat_app/src/core/helper/context_extension.dart';
import '../../core/constants/app_strings.dart';
import '../../core/helper/prefs.dart';
import '../../core/sl.dart';
import '../../data/repo/chat_repo.dart';
import '../../view_model/chat/chat_cubit.dart';
import '../../view_model/contacts/contacts_cubit.dart';
import '../widgets/widgets.dart';
import 'chat_page.dart';

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
    );
  }
}
