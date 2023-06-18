import 'package:flutter/material.dart';

class UserModel {
  final String name;
  final String email;
   String phoneNumber;
  String profilePic;
   String uid;
  final String bio;
  String createdAt;

  UserModel(
      {required this.name, required this.email, required this.phoneNumber, required this.profilePic, required this.uid,
        required this.bio, required this.createdAt});


  //from map => getting data from server
  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        profilePic: map['profilePic'] ?? '',
        uid: map['uid'] ?? '',
        bio: map['bio'] ?? '',
        createdAt: map['createdAt'] ?? ''//
    );
  }

  //to map=> sending data to server

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'bio': bio,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
    };
  }

}
