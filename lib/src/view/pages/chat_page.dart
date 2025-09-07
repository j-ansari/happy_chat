import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/sl.dart';
import '../../data/model/contact.dart';
import '../../data/model/message.dart';
import '../../data/repo/chat_repo.dart';
import '../../view_model/chat/chat_cubit.dart';

class ChatPage extends StatefulWidget {
  final Contact contact;

  const ChatPage({super.key, required this.contact});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatCubit? cubit;
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final token = prefs.getString('token')!;
      cubit = ChatCubit(getIt<ChatRepo>(), token);
      cubit?.connectWithContacts(widget.contact.token);
      setState(() {});
    });
  }

  @override
  void dispose() {
    cubit?.close();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cubit == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocProvider.value(
      value: cubit!,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.contact.name)),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, List<Message>>(
                builder: (context, messages) {
                  if (messages.isEmpty) {
                    return const Center(child: Text(""));
                  }
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (c, i) {
                      final m = messages[i];

                      return ListTile(title: Text(m.text));
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(child: TextField(controller: _ctrl)),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    context.read<ChatCubit>().sendMessage(
                      widget.contact.token,
                      _ctrl.text.trim(),
                    );
                    _ctrl.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
