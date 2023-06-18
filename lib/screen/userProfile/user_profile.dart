import 'dart:io';
import 'package:firebase_phone_auth/model/user_model.dart';
import 'package:firebase_phone_auth/provider/auth_provider.dart';
import 'package:firebase_phone_auth/screen/homeScreen/home_screen.dart';
import 'package:firebase_phone_auth/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:firebase_phone_auth/constants/colors.dart';
import 'package:firebase_phone_auth/widgets_custom/custom_button.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  //for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context).isLoading;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => selectImage(),
                          child: image == null
                              ? CircleAvatar(
                                  backgroundColor: kPrimaryColor,
                                  radius: 70,
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 70,
                                    color: Colors.white,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                  radius: 50,
                                ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              textField(
                                  hintText: 'Prashanna Raj',
                                  icon: Icons.account_circle,
                                  inputType: TextInputType.name,
                                  maxLines: 1,
                                  controller: nameController),
                              textField(
                                  hintText: 'prashannaraj5@gmail.com',
                                  icon: Icons.email_outlined,
                                  inputType: TextInputType.emailAddress,
                                  maxLines: 1,
                                  controller: emailController),
                              textField(
                                  hintText: 'enter your bio here...',
                                  icon: Icons.edit,
                                  inputType: TextInputType.name,
                                  maxLines: 1,
                                  controller: bioController),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: CustomButton(
                            text: 'Continue',
                            onPress: () => storeData(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget textField(
      {required String hintText,
      required IconData icon,
      required TextInputType inputType,
      required int maxLines,
      required TextEditingController controller}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: kPrimaryColor,
        maxLines: maxLines,
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 10),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: kPrimaryColor)),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: kPrimaryColorLight,
          filled: true,
        ),
      ),
    );
  }

  void storeData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: '',
        profilePic: '',
        uid: '',
        bio: bioController.text.trim(),
        createdAt: '');
    if (image != null) {
      authProvider.saveUserDataToFirebase(
          context: context,
          userModel: userModel,
          profilePic: image!,
          onSuccess: () {
            // once the data is saved we need to store locally also
            authProvider.saveUserDataLocallyToSP().then((value) {
              authProvider.setSignIn().then((value) =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false));
            });
          });
    } else {
      showSnakBar(context, 'Please upload your profile pic');
    }
  }
}
