class Contact {
  final int? id;
  final String? name;
  final String? email;
  double? balance;
  final int? accountNumber;

  Contact(this.id, this.name, this.email, this.accountNumber, this.balance);

  @override
  String toString() {
    return "Contact{id: $id, name: $name, email: $email, accountNumber: $accountNumber, balance: $balance}";
  }

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        accountNumber = json['accountNumber'],
        balance = json['balance'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'accountNumber': accountNumber,
        'balance': balance,
      };
}
