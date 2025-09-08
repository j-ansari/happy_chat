class ContactDto {
  final List<ContactsItem>? contacts;

  const ContactDto({this.contacts});

  factory ContactDto.fromJson(Map<String, dynamic> json) {
    final data = <ContactsItem>[];
    if (json['data'] != null) {
      json['data'].forEach((e) {
        data.add(ContactsItem.fromJson(e));
      });
    }
    return ContactDto(contacts: data);
  }
}

class ContactsItem {
  final String name;
  final String token;

  ContactsItem({required this.name, required this.token});

  factory ContactsItem.fromJson(Map<String, dynamic> json) =>
      ContactsItem(name: json['name'], token: json['token']);
}
