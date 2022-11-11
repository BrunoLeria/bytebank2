class Contact {
  final int? id;
  final String? name;
  final String? email;
  final int? accountNumber;

  Contact(this.id, this.name, this.email, this.accountNumber);

  @override
  String toString() {
    return "Contact{id: $id, name: $name, email: $email, accountNumber: $accountNumber}";
  }

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        accountNumber = json['accountNumber'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'accountNumber': accountNumber,
      };
}
