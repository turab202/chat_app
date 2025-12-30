import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: Constants.apiKey,
          appId: Constants.appId,
          messagingSenderId: Constants.messagingSenderId,
          projectId: Constants.projectId,
          // Add these required fields for web:
          authDomain: "${Constants.projectId}.firebaseapp.com",
          storageBucket: "${Constants.projectId}.appspot.com",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    
    print("Firebase initialized successfully");
    runApp(const MyApp());
  } catch (e) {
    print("Firebase initialization error: $e");
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            "Firebase Error: $e\n\n"
            "Please check your Firebase configuration.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    try {
      await HelperFunctions.getUserLoggedInStatus().then((value) {
        if (value != null) {
          setState(() {
            _isSignedIn = value;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print("Error getting login status: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Constants.primaryColor, // Use static access
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants.primaryColor, // Use static access
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}