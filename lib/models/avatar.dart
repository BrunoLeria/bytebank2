import 'dart:convert';

import 'package:flutter/material.dart';

class Avatar {
  final int? id;
  String? imagem;
  final String? email;

  Avatar(this.id, this.imagem, this.email);

  @override
  String toString() {
    return "Avatar{id: $id, imagem: $imagem, email: $email";
  }

  Image imageFromBase64String(double? width, double? height) {
    return Image.memory(base64Decode(imagem!), width: width, height: height,);
  }  
}
