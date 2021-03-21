import 'package:flutter/material.dart';
import 'package:gp_version_01/Screens/favorites_screen.dart';
import 'package:gp_version_01/Screens/formSkeleton_screen.dart';
import 'package:gp_version_01/Screens/details_screen.dart';
import 'package:gp_version_01/Screens/home_screen.dart';
import 'package:gp_version_01/Screens/make_offer.dart';
import 'package:gp_version_01/Screens/myProducts_screen.dart';
import 'package:gp_version_01/Screens/recommend_screen.dart';
import 'package:gp_version_01/Screens/tabs_Screen.dart';
import 'package:gp_version_01/Screens/image_screen.dart';

import 'Screens/ChatDetailPage.dart';
import 'Screens/chooseCategory_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        tabBarTheme: TabBarTheme(labelStyle: GoogleFonts.cairo()),
        appBarTheme: AppBarTheme(textTheme: GoogleFonts.cairoTextTheme()),
        bottomAppBarColor: Colors.blue[400],

        buttonColor: Colors.blue[400],
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.blue[400],
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      routes: {
        "/": (context) => TabsScreen(),
        HomeScreen.route: (context) => HomeScreen(),
        Details.route: (context) => Details(),
        AddItemScreen.route: (context) => AddItemScreen(),
        ImageScreen.route: (context) => ImageScreen(),
        ChooseCategoryScreen.route: (context) => ChooseCategoryScreen(),
        Favorites.route: (context) => Favorites(),
        Recommend.route: (context) => Recommend(),
        MyProducts.route: (context) => MyProducts(),
        MakeOffer.route: (context) => MakeOffer(),
        ChatDetailPage.route: (context) => ChatDetailPage(),
      },
    );
  }
}
