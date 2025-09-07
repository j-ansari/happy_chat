import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import '../../data/model/message.dart';
import '../../data/model/messages.dart';
import '../../data/repo/chat_repo.dart';

class ChatCubit extends Cubit<List<Message>> {
  final ChatRepo repo;
  final String myToken;

  ChatCubit(this.repo, this.myToken) : super([]) {
    repo.messages.listen((payload) {
      try {
        final map = _stringToMap(payload);
        final dto = MessageDto.fromJson(map);
        final m = Message(
          from: dto.from,
          to: dto.to,
          text: dto.message,
          timestamp: DateTime.parse(dto.timestamp),
        );
        emit(List.from(state)..add(m));
      } catch (_) {}
    });
  }

  Map<String, dynamic> _stringToMap(String s) {
    try {
      return json.decode(s) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Invalid payload');
    }
  }

  Future<void> connectWithContacts(String contactToken) async {
    final topic = 'challenge/user/$contactToken/$myToken/';
    await repo.connect();
    await repo.subscribe(topic);

    repo.messages.listen((payload) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        final dto = MessageDto.fromJson(data);

        final msg = Message(
          from: dto.from,
          to: dto.to,
          text: dto.message,
          timestamp: DateTime.parse(dto.timestamp),
        );

        emit(List.from(state)..add(msg));
      } catch (e) {
        debugPrint("Failed to parse incoming message: $e");
      }
    });
  }

  Future<void> sendMessage(String contactToken, String text) async {
    if (text.isEmpty) return;

    final topic = 'challenge/user/$contactToken/$myToken/';
    final dto = MessageDto(
      from: myToken,
      to: contactToken,
      message: text,
      timestamp: DateTime.now().toIso8601String(),
    );
    await repo.publish(topic, dto);

    final m = Message(
      from: myToken,
      to: contactToken,
      text: text,
      timestamp: DateTime.now(),
    );
    emit(List.from(state)..add(m));
  }
}
