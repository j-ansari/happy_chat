import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_chat_app/src/view_model/chat/chat_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/sl.dart';
import '../../data/repo/chat_repo.dart';
import '../../view_model/contacts/contacts_cubit.dart';
import '../widgets/widgets.dart';
import 'chat_page.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ContactsCubit>();
    cubit.load();
    return BaseWidget(
      hasSearch: true,
      hasAvatar: true,
      body: BlocBuilder<ContactsCubit, List>(
        builder: (context, contacts) {
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (c, i) {
              final contact = contacts[i];
              return ListTile(
                title: Text(contact.name),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create:
                                (context) => ChatCubit(
                                  getIt<ChatRepo>(),
                                  prefs.getString('token')!,
                                ),
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
