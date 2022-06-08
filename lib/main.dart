import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_instagram_clone/firebase_options.dart';
import 'package:flutter_instagram_clone/globals/globals.dart';
import 'package:flutter_instagram_clone/globals/themes.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/services/auth_services.dart';
import 'package:flutter_instagram_clone/pages/log_in_page.dart';
import 'package:flutter_instagram_clone/pages/app_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Instagram Clone',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: globalSnackbarKey,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
        ),
        home: StreamBuilder(
          stream: AuthServices.authStateChanges(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return const AppLayout();
            }

            return const LoginPage();
          },
        ),
      ),
    );
  }
}
