class Contact {
  final int? id;
  final String? name;
  final String? email;
  String? password;
  double? balance;
  final int? accountNumber;
  String? image;

  Contact(this.id, this.name, this.email, this.accountNumber);

  @override
  String toString() {
    return "Contact{id: $id, name: $name, email: $email, password: $password, accountNumber: $accountNumber, balance: $balance}";
  }

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        password = json['password'],
        accountNumber = json['accountNumber'],
        balance = json['balance'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'accountNumber': accountNumber,
        'balance': balance,
      };
}
