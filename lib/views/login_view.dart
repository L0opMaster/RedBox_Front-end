import 'package:flutter/material.dart';
import 'package:front_redbox/routes/app_routes.dart';
import 'package:front_redbox/routes/app_transition.dart';
import 'package:front_redbox/service/auth_service.dart';
import 'package:front_redbox/views/register_view.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Focus nodes for smooth keyboard navigation
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final AuthService authService = AuthService();
  bool isVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Dismiss keyboard before showing dialog
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await authService.login(
        usernameOrEmail: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Check if widget is still in the tree before navigating
      if (!mounted) return;
      Navigator.pop(context); // Pop loading dialog

      if (response != null) {
        print(response.user.username);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.ontap,
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Pop loading dialog

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Log in',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset:
          true, // Set to true so scroll view can adapt to keyboard
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Keeps card compact
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/red_box.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback if asset is missing
                          return Container(
                            width: 120,
                            height: 120,
                            color: Colors.red,
                            child: const Icon(
                              Icons.check_box_outline_blank,
                              size: 50,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _usernameController,
                      focusNode: _usernameFocus,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email or Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? "Email or Username is required"
                          : null,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      obscureText: !isVisible,
                      textInputAction: TextInputAction.done,

                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Password is required"
                          : null,
                      onFieldSubmitted: (_) => handleLogin(),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 48, // Standard button height
                      child: FilledButton(
                        onPressed: handleLogin,
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          AppTransition(millisecond: 300).slide(RegisterView()),
                        );
                      },
                      child: Text(
                        'I don\'t have account.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
