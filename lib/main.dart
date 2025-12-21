import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kelompok6_sportareamanagement/screens/home/main_layout.dart';
import 'package:kelompok6_sportareamanagement/screens/auth/auth_screen.dart';
import 'package:kelompok6_sportareamanagement/services/auth_service.dart';
import 'package:kelompok6_sportareamanagement/screens/admin/admin_main_layout.dart';
import 'package:kelompok6_sportareamanagement/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  await AuthService.logout();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sport Arena',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF22c55e),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF22c55e),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: currentMode,
          home: FutureBuilder<bool>(
            future: AuthService.isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.data == true) {
                return FutureBuilder<String?>(
                  future: AuthService.getUserRole(),
                  builder: (context, roleSnapshot) {
                    if (roleSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (roleSnapshot.data == 'admin') {
                      return const AdminMainLayout();
                    } else {
                      return const MainLayout();
                    }
                  },
                );
              } else {
                return const AuthScreen();
              }
            },
          ),
        );
      },
    );
  }
}
