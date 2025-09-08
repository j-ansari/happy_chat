class MessageDto {
  final String from;
  final String to;
  final String message;
  final String timestamp;

  MessageDto({
    required this.from,
    required this.to,
    required this.message,
    required this.timestamp,
  });

  factory MessageDto.fromJson(Map<String, dynamic> j) => MessageDto(
    from: j['from'],
    to: j['to'],
    message: j['message'],
    timestamp: j['timestamp'],
  );

  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
    'message': message,
    'timestamp': timestamp,
  };
}
