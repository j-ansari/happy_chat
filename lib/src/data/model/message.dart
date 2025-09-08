import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String from;
  final String to;
  final String text;
  final DateTime timestamp;
  final bool isMine;

  const Message({
    required this.from,
    required this.to,
    required this.text,
    required this.timestamp,
    required this.isMine,
  });

  @override
  List<Object?> get props => [from, to, text, timestamp, isMine];
}
