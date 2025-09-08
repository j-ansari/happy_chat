import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/contact.dart';
import '../../data/repo/contact_repo.dart';

class ContactsCubit extends Cubit<List<Contact>> {
  final ContactRepo repo;

  ContactsCubit(this.repo) : super([]);

  Future<void> load() async {
    final list = await repo.fetchContacts();
    emit(list);
  }
}
