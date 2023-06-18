import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth/provider/auth_provider.dart';
import 'package:firebase_phone_auth/screen/homeScreen/home_screen.dart';
import 'package:firebase_phone_auth/screen/resiteration/registration.dart';
import 'package:firebase_phone_auth/widgets_custom/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 40 ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/images/signin.jpg'),
                height: 350,width: 350,),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Let\'s get started',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Never a better time than now to start.',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                        text: 'Get Started',
                        onPress: () async {
                          if (authProvider.isSignedIn == true) {
                            await authProvider
                                .getDataLocallyFromSP()
                                .whenComplete(
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  ),
                                );
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationScreen()));
                          }
                        }))
              ],
            ),
          )),
    );
  }
}
