import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_chat_app/src/core/helper/context_extension.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_strings.dart';
import '../../core/helper/prefs.dart';
import '../../core/sl.dart';
import '../../data/dto/contact.dart';
import '../../data/dto/message.dart';
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
  late ChatCubit cubit;
  final chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final token = Preferences.getString(PrefsKey.token)!;
    cubit = ChatCubit(getIt<ChatRepo>(), token);
    cubit.connectWithContacts(widget.contact.token);
    setState(() {});
  }

  @override
  void dispose() {
    cubit.close();
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      hasAppBar: true,
      hasAvatar: true,
      appBarTitle: widget.contact.name,
      padding: 0,
      body: BlocProvider.value(
        value: cubit,
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
                    AppStrings.notEnteredWorld,
                    style: context.textTheme.titleLarge?.copyWith(fontSize: 14),
                  ),
                  Text(
                    AppStrings.createPortalForFriend,
                    style: context.textTheme.titleLarge?.copyWith(fontSize: 14),
                  ),
                ],
              );
            }
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final showDateHeader = index % 2 == 0;
                final m = messages[index];
                return Column(
                  children: [
                    if (showDateHeader) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _formatDate(m.timestamp),
                          style: context.textTheme.bodySmall,
                        ),
                      ),
                    ],
                    Align(
                      alignment:
                          m.isMine
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              m.isMine ? Color(0xfff6beb1) : Color(0xfffbdeac),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(m.text),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      fab: CustomTextField(
        controller: chatController,
        label: AppStrings.writeMessage,
        borderColor: Colors.transparent,
        bgColor: context.colorSchema.error.withAlpha(20),
        maxLines: 3,
        prefix: IconButton(
          icon: const Icon(Icons.send, color: Colors.black),
          onPressed: () {
            context.read<ChatCubit>().sendMessage(
              widget.contact.token,
              chatController.text.trim(),
            );
            chatController.clear();
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final j = dateTime.toJalali();
    return "${j.day} ${j.formatter.mN}";
  }
}
