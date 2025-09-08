import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_chat_app/src/core/constants/app_images.dart';
import 'package:happy_chat_app/src/core/helper/context_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/sl.dart';
import '../../data/model/contact.dart';
import '../../data/model/message.dart';
import '../../data/repo/chat_repo.dart';
import '../../view_model/chat/chat_cubit.dart';
import '../widgets/widgets.dart';

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
      child: BaseWidget(
        hasAppBar: true,
        hasAvatar: true,
        appBarTitle: widget.contact.name,
        padding: 0,
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, List<Message>>(
                builder: (context, messages) {
                  if (messages.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(AppImages.bg),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'هنوز به این دنیا وارد نشدی.',
                          style: context.textTheme.titleLarge?.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'یه پورتال بزن به گوشی رفیقت.',
                          style: context.textTheme.titleLarge?.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final m = messages[index];
                      return Align(
                        alignment:
                            m.isMine
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                m.isMine
                                    ? Color(0xfff6beb1)
                                    : Color(0xfffbdeac),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(m.text),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        fab: CustomTextField(
          controller: _ctrl,
          label: 'نوشتن پیام...',
          borderColor: Colors.transparent,
          bgColor: context.colorSchema.error.withAlpha(20),
          prefix: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              context.read<ChatCubit>().sendMessage(
                widget.contact.token,
                _ctrl.text.trim(),
              );
              _ctrl.clear();
            },
          ),
        ),
      ),
    );
  }
}
