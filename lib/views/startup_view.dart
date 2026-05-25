import 'package:flutter/material.dart';
import 'package:front_redbox/core/storage_service.dart';
import 'package:front_redbox/routes/app_transition.dart';
import 'package:front_redbox/bottomNavigator/ontap_view.dart';
import 'package:front_redbox/views/welcome_view.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  // Tracks whether to show the loading indicator
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkAuth();
    });
  }

  Future<void> checkAuth() async {
    // 1. Initial 2-second wait (Indicator is visible)
    await Future.delayed(const Duration(seconds: 2));

    // Fetch the login state
    bool isLoggedIn = await StorageService.isLoggedIn();

    if (!mounted) return;

    // 2. Turn off the loading indicator before starting the 500ms delay
    setState(() {
      _isLoading = false;
    });

    // 3. Additional 500-millisecond wait (Indicator is now hidden)
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    
    // 4. Perform the route transition
    Navigator.pushReplacement(
      context,
      AppTransition(
        millisecond: 300,
      ).slide(isLoggedIn ? const OntapView() : const WelcomeView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Conditionally show the indicator based on _isLoading state
            if (_isLoading)
              SizedBox(
                width: media.width * 0.6,
                height: media.width * 0.6,
                child: const CircularProgressIndicator(strokeWidth: 4),
              ),
            ClipOval(
              child: Image.asset(
                'assets/images/red_box.png',
                width: media.width * 0.5,
                height: media.width * 0.5,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}