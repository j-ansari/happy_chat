import 'dart:convert';

import '../data_source/mqtt_client.dart';
import '../model/messages.dart';

class ChatRepo {
  final MqttService mqtt;

  ChatRepo(this.mqtt);

  Future<void> connect() => mqtt.connect();

  Future<void> publish(String topic, MessageDto dto) async {
    final payload = jsonEncode(dto.toJson());
    await mqtt.publish(topic, payload);
  }

  Future<void> subscribe(String topic) async {
    await mqtt.subscribe(topic);
  }

  Stream<String> get messages => mqtt.messages;
}
