import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techstuff/providers/cart_provider.dart';
import 'package:techstuff/providers/order_provider.dart';
import 'package:techstuff/screens/auth/user_information.dart';
import 'package:techstuff/screens/navigationBar/category_screen.dart';
import 'package:techstuff/screens/navigationBar/home_screen.dart';
import 'package:techstuff/screens/auth/login_screen.dart';
import 'package:techstuff/screens/auth/signup_screen.dart';
import 'package:techstuff/screens/AppScreens/splash_screen.dart';
import 'package:techstuff/screens/AppScreens/subCat_screen.dart';
import 'package:techstuff/widgets/bottomNavBar.dart';

import 'providers/product_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/splash': (context) => SplashScreen(),
          '/userInformationScreen': (context) => UserInformationScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/bottomNavBar': (context) => BottomNavBar(),
          '/home': (context) => HomeScreen(),
          '/category': (context) => Categorycreen(),
          '/subCat': (context) => SubCatScreen(),
        },
        title: 'TechStuff',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
