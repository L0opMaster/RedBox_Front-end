import 'package:flutter/material.dart';
import 'package:front_redbox/routes/app_routes.dart';
import 'package:front_redbox/routes/app_transition.dart';
import 'package:front_redbox/views/login_view.dart';
import 'package:front_redbox/views/register_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100, left: 15, right: 15),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: media.width * 0.7,
                height: media.height * 0.15,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: media.width * 0.7,
                  height: media.height * 0.15,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: media.width * 0.5,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      AppTransition(millisecond: 300).slide(const Login()),
                    );
                  },
                  label: Text('Log in'),
                  icon: Icon(Icons.login_outlined),
                ),
              ),

              SizedBox(
                width: media.width * 0.5,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      AppTransition(millisecond: 300).slide(const RegisterView()),
                    );
                  },
                  label: Text('Register'),
                  icon: Icon(Icons.app_registration_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
