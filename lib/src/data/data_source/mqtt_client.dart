import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  static const host = '193.105.234.224';
  static const port = 1883;
  static const username = 'challenge';
  static const password = 'sdjSD12\$5sd';

  late MqttServerClient _client;
  final _messageController = StreamController<String>.broadcast();
  String? _currentTopic;

  Stream<String> get messages => _messageController.stream;

  MqttService();

  Future<void> init() async {
    _client = MqttServerClient(
      host,
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
    );
    _client.port = port;
    _client.logging(on: false);
    _client.keepAlivePeriod = 20;
    _client.secure = false;

    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(_client.clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client.connectionMessage = connMess;
  }

  Future<void> connect() async {
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      return;
    }

    try {
      await _client.connect(username, password);
      _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );
        _messageController.add(payload);
      });
    } catch (e) {
      disconnect();
      rethrow;
    }
  }

  Future<void> publish(String topic, String payload) async {
    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      await connect();
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  Future<void> subscribe(String topic) async {
    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      await connect();
    }

    if (_currentTopic != null) {
      _client.unsubscribe(_currentTopic!);
    }

    _currentTopic = topic;
    _client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void disconnect() {
    _client.disconnect();
  }

  void _onDisconnected() {
    print("MQTT disconnected!");
  }

  void _onConnected() {
    if (_currentTopic != null) {
      _client.subscribe(_currentTopic!, MqttQos.atLeastOnce);
    }
  }

  void dispose() {
    _messageController.close();
    disconnect();
  }
}
