import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? phone;
  String? email;
  String? id;
  String? name;
  String? address;

  UserModel({this.phone, this.email, this.id, this.name, this.address});

  UserModel.fromSnapshot(DataSnapshot snap) {
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    address = (snap.value as dynamic)["address"];
    email = (snap.value as dynamic)["email"];
    id = snap.key;
  }
}
