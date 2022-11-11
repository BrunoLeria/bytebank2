class Contact {
  final int? id;
  final String? name;
  final int? accountNumber;
  final int? userId;

  Contact(this.id, this.name, this.accountNumber, this.userId);

  @override
  String toString() {
    return "Contact{id: $id, name: $name, accountNumber: $accountNumber, userId: $userId}";
  }

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        accountNumber = json['accountNumber'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'accountNumber': accountNumber,
        'userId': userId,
      };
}
