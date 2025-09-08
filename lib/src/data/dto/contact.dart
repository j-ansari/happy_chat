import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  final String name;
  final String token;

  const Contact({required this.name, required this.token});

  @override
  List<Object?> get props => [name, token];
}
