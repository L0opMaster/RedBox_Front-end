// import 'package:flutter/material.dart';
// import 'package:front_redbox/provider/auth_provider.dart';
// import 'package:front_redbox/provider/theme_provider.dart';
// import 'package:front_redbox/routes/app_routes.dart';
// import 'package:front_redbox/bottomNavigator/ontap_view.dart';
// import 'package:front_redbox/views/login_view.dart';
// import 'package:front_redbox/views/register_view.dart';
// import 'package:front_redbox/views/startup_view.dart';
// import 'package:front_redbox/views/welcome_view.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'RedBox Digital Menu',

//       // 1. Light Theme Configuration
//       theme: ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.light,
//         colorScheme: const ColorScheme.light(
//           primary: Color(0xFFD90429),
//           primaryContainer: Color(0xFFFFEAEB),
//           secondary: Color(0xFFEF233C),
//           background: Color(0xFFFAFAFA),
//           surface: Color(0xFFFFFFFF),
//           onBackground: Color(0xFF1A1A1A),
//           onSurface: Color(0xFF2B2B2B),
//           error: Color(0xFFBA1A1A),
//         ),
//         cardTheme: const CardThemeData(color: Color(0xFFFFFFFF), elevation: 4),
//       ),

//       // 2. Dark Theme Configuration
//       darkTheme: ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.dark,
//         colorScheme: const ColorScheme.dark(
//           primary: Color(0xFFEF233C),
//           primaryContainer: Color(0xFF4A0E17),
//           secondary: Color(0xFFD90429),
//           background: Color(0xFF121212),
//           surface: Color(0xFF1E1E1E),
//           onBackground: Color(0xFFF5F5F5),
//           onSurface: Color(0xFFE0E0E0),
//           error: Color(0xFFFFB4AB),
//         ),
//         cardTheme: const CardThemeData(color: Color(0xFF1E1E1E), elevation: 0),
//       ),

//       // 3. Follow system settings for dark/light mode automatically
//       themeMode: themeProvider.themeMode,

//       initialRoute: AppRoutes.startup,
//       routes: {
//         AppRoutes.startup: (context) => const StartupView(),
//         AppRoutes.welcome: (context) => const WelcomeView(),
//         AppRoutes.login: (context) => const Login(),
//         AppRoutes.register: (context) => RegisterView(),
//         AppRoutes.ontap: (context) => OntapView(),
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:front_redbox/provider/auth_provider.dart';
import 'package:front_redbox/provider/theme_provider.dart';
import 'package:front_redbox/routes/app_routes.dart';
import 'package:front_redbox/bottomNavigator/ontap_view.dart';
import 'package:front_redbox/views/login_view.dart';
import 'package:front_redbox/views/register_view.dart';
import 'package:front_redbox/views/startup_view.dart';
import 'package:front_redbox/views/welcome_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RedBox Digital Menu',

      themeMode: themeProvider.themeMode,

      // ================= LIGHT THEME =================
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        colorScheme: const ColorScheme.light(
          // Main Brand Colors
          primary: Color(0xFFD90429),
          secondary: Color(0xFFEF233C),

          // Background Colors
          background: Color(0xFFF5F5F5),
          surface: Colors.white,

          // Text Colors
          onBackground: Color(0xFF1A1A1A),
          onSurface: Color(0xFF2B2B2B),

          // Text on Primary
          onPrimary: Colors.white,

          // Extra
          primaryContainer: Color(0xFFFFEAEB),
          error: Color(0xFFBA1A1A),
        ),

        scaffoldBackgroundColor: const Color(0xFFF5F5F5),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFD90429),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // ================= DARK THEME =================
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        colorScheme: const ColorScheme.dark(
          // Main Brand Colors
          primary: Color(0xFFEF233C),
          secondary: Color(0xFFD90429),

          // Background Colors
          background: Color(0xFF121212),
          surface: Color(0xFF1E1E1E),

          // Text Colors
          onBackground: Colors.white,
          onSurface: Color(0xFFE0E0E0),

          // Text on Primary
          onPrimary: Colors.white,

          // Extra
          primaryContainer: Color(0xFF4A0E17),
          error: Color(0xFFFFB4AB),
        ),

        scaffoldBackgroundColor: const Color(0xFF121212),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        cardTheme: CardThemeData(
          color: Color(0xFF292929),
          elevation: 2,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      initialRoute: AppRoutes.startup,

      routes: {
        AppRoutes.startup: (context) => const StartupView(),
        AppRoutes.welcome: (context) => const WelcomeView(),
        AppRoutes.login: (context) => const Login(),
        AppRoutes.register: (context) => RegisterView(),
        AppRoutes.ontap: (context) => OntapView(),
      },
    );
  }
}
