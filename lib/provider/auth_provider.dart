import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth/model/user_model.dart';
import 'package:firebase_phone_auth/screen/otp/otp_screen.dart';
import 'package:firebase_phone_auth/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  UserModel? _userModel;

  UserModel get userModel => _userModel!;


  String? _uid;

  String get uid => _uid!;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthProvider() {
    checkSign();
  }


  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  //sign in
  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      print(phoneNumber);
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            if (error.code == 'invalid-phone-number') {
              showSnakBar(context, error.message.toString());
            } else {
              showSnakBar(context, error.message.toString());
              print(error.message.toString());
            }
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationID: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationID) {});

    } on FirebaseAuthException catch (e) {
      showSnakBar(context, e.message.toString());
    }
  }

  // verify otp
  void verifyOTP({required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await _firebaseAuth.signInWithCredential(credential)).user!;

      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnakBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }


  // database operations
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await _firebaseFirestore.collection("users")
        .doc(_uid)
        .get();

    if (snapshot.exists) {
      print("User Exists");
      return true;
    } else {
      print('New user');
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
// first we are storing the image to firebase storage.
      await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
        userModel.profilePic = value;
        userModel.createdAt = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = _firebaseAuth.currentUser!.uid;
      });
      _userModel = userModel;
      await _firebaseFirestore.collection('users').doc(_uid).set(
          userModel.toMap()).then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnakBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String refPath, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(refPath).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore.collection("users").doc(
        _firebaseAuth.currentUser!.uid).get().then((DocumentSnapshot snapshot) {
      _userModel = UserModel(name: snapshot['name'],
          email: snapshot['email'],
          phoneNumber: snapshot['phoneNumber'],
          profilePic: snapshot['profilePic'],
          uid: snapshot['uid'],
          bio: snapshot['bio'],
          createdAt: snapshot['createdAt']);
      _uid=userModel.uid;
    });
  }


//storing data locally using shared preferences
  Future saveUserDataLocallyToSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        "user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataLocallyFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

// logout function
  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }
}
