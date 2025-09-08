import '../data_source/api_service.dart';
import '../dto/contact.dart';
import '../dto/contacts.dart';

class ContactRepo {
  final ApiService api;

  ContactRepo(this.api);

  Future<List<Contact>> fetchContacts() async {
    final resp = await api.dio.get('/api/v1/contacts');
    final list = ContactDto.fromJson(resp.data);
    final a = <Contact>[];
    for (final l in list.contacts!) {
      a.add(Contact(name: l.name, token: l.token));
    }
    return a;
  }
}
