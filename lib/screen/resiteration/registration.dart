import 'package:firebase_phone_auth/constants/colors.dart';
import 'package:firebase_phone_auth/widgets_custom/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController phoneController = TextEditingController();

  Country selectedCountry = Country(
      phoneCode: "977",
      countryCode: "NP",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Nepal",
      example: "Nepal",
      displayName: "Nepal",
      displayNameNoCountryCode: "NP",
      e164Key: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              children: [
                Image(image: AssetImage('assets/images/image1.jpg'),
                  height: 300,
                  width: 300,),
                SizedBox(height: 30,),
                Text('Register',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                ), SizedBox(height: 15,),
                Text(
                  'Add Your Phone Number. A verification code will be sent to that number',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40,),
                TextFormField(

                  cursorColor: kPrimaryColor,
                  controller: phoneController,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                  decoration: InputDecoration(
                      hintText: 'Enter phone number',

                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black54)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: kPrimaryColor)
                      ),
                      prefixIcon: Container(
                        padding: EdgeInsets.all(8),
                        child: InkWell(
                          onTap: (){
                            showCountryPicker(context: (context),
                                countryListTheme: CountryListThemeData(
                                  bottomSheetHeight: 600,
                                ),
                                onSelect: (value){
                              setState(() {
                                selectedCountry=value;
                                print(selectedCountry);
                              });
                            });
                          },
                          child: Text("${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      )
                  ),
                ),
                SizedBox(height: 30,),
                SizedBox(
                  width: double.infinity,height: 50,
                    child: CustomButton(text: 'Login', onPress: ()=>sendPhoneNumber()))


              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber(){
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber=phoneController.text.trim();
    authProvider.signInWithPhone(context,"+${selectedCountry.phoneCode}$phoneNumber");


  }
}
