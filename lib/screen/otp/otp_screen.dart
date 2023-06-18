import 'package:firebase_phone_auth/constants/colors.dart';
import 'package:firebase_phone_auth/provider/auth_provider.dart';
import 'package:firebase_phone_auth/screen/homeScreen/home_screen.dart';
import 'package:firebase_phone_auth/screen/userProfile/user_profile.dart';
import 'package:firebase_phone_auth/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../widgets_custom/custom_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.verificationID}) : super(key: key);
  final String verificationID;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              )
            : Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                      Image(
                        image: AssetImage('assets/images/image1.jpg'),
                        height: 250,
                        width: 250,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Verification',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Enter the OTP send to your Phone Number',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black54),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Pinput(
                        length: 6,
                        showCursor: true,
                        onCompleted: (value) {
                          setState(() {
                            otpCode = value;
                          });
                        },
                        defaultPinTheme: PinTheme(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kPrimaryColor)),
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CustomButton(
                          text: 'Verify',
                          onPress: () {
                            if (otpCode != null) {
                              verifyOtp(context, otpCode!);
                            } else {
                              showSnakBar(context, 'Enter 6-Digit OTP code.');
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text.rich(
                            TextSpan(
                              text: 'Didn\'t receive any code?',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black54),
                              children: [
                                TextSpan(
                                    text: 'Resend',
                                    style: TextStyle(color: kPrimaryColor))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void verifyOtp(BuildContext context, String userOtp) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.verifyOTP(
      context: context,
      verificationId: widget.verificationID,
      userOtp: userOtp,
      onSuccess: () {
        //checking weather user exists in the db
        authProvider.checkExistingUser().then(
          (value) {
            if (value == true) {
              //user exists in db
              authProvider.getDataFromFirestore().then(
                    (value) => authProvider.saveUserDataLocallyToSP().then(
                        (value) => authProvider.setSignIn().then((value) =>
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                (route) => false))),
                  );
            } else {
              //new user
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()),
                  (route) => false);
            }
          },
        );
      },
    );
  }
}
