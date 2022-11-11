class Contact {
  final int? id;
  final String? name;
  final String? email;

  Contact(this.id, this.name, this.email);

  @override
  String toString() {
    return "Contact{id: $id, name: $name, email: $email}";
  }

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
}
