import 'package:firebase_phone_auth/constants/colors.dart';
import 'package:firebase_phone_auth/provider/auth_provider.dart';
import 'package:firebase_phone_auth/screen/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
              onPressed: () {
                authProvider.userSignOut().then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      ),
                    );
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 10),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                //backgroundColor: kPrimaryColorLight,
                backgroundImage:
                    NetworkImage(authProvider.userModel.profilePic),
                radius: 100,
              ),
              SizedBox(
                height: 20,
              ),
              Text(authProvider.userModel.name,style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),),
              SizedBox(height: 10,),
              Text(authProvider.userModel.bio,style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54
              ),),
              SizedBox(height: 20,),
              UserInfoCard(authProvider: authProvider, iconData: Icons.email, text: authProvider.userModel.email,),
              SizedBox(height: 10,),
              UserInfoCard(authProvider: authProvider, iconData: Icons.phone_iphone_sharp, text: authProvider.userModel.phoneNumber,),

            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.authProvider, required this.iconData, required this.text,
  });

  final AuthProvider authProvider;
  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPrimaryColorLight,
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: ListTile(
        leading: Icon(iconData,
        color: kPrimaryColor,),
        title: Text(text),
      ),
    );
  }
}
