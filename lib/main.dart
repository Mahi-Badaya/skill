import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intro/responsive/mobile_screen_layout.dart';
import 'package:intro/responsive/responsive_screen.dart';
import 'package:intro/responsive/web_screen_layout.dart';
import 'package:intro/screens/home_screen.dart';
import 'package:intro/screens/login_screen.dart';
import 'package:intro/screens/signup_screen.dart';
import 'package:intro/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDhjvby0tpyYAYO6k9Y1s06g8lCU4qP_04',
        appId: '1:233056447495:web:b53718034915930c898ea2',
        messagingSenderId: '233056447495',
        projectId: 'intro-5208b',
        storageBucket: 'intro-5208b.appspot.com',
      ),
    );
  }else{
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: StreamBuilder( //to persist the state of the user logged in
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
             return const ResponsiveLayout(webScreenLayout: WebScreenLayout(), mobileScreenLayout: HomeScreen(),);
            }
            else if(snapshot.hasError){
              return Center(child: Text('${snapshot.error}'),);
            }
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(color: primaryColor,) ,
            );
          }
          return LoginScreen();
        },
      ),
    );
  }
}

