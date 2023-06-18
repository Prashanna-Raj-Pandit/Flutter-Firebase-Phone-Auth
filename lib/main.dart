import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth/provider/auth_provider.dart';
import 'package:firebase_phone_auth/screen/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
      ),
    );
  }
}
