import 'package:flutter/material.dart';
import 'package:front_redbox/routes/app_routes.dart';
import 'package:front_redbox/service/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  final TextEditingController conPassword = TextEditingController();

  bool conVisibility = true;
  bool passVisibility = true;

  @override
  void dispose() {
    // TODO: implement dispose
    firstName.dispose();
    lastName.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    dateOfBirth.dispose();
    conPassword.dispose();
    super.dispose();
  }

  Widget buildTextField({
    TextEditingController? controller,
    required BuildContext context,
    Widget? suffixIcon,
    required String title,
    required String hintText,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.labelLarge?.fontSize ?? 14,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            labelText: hintText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$title is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await authService.register(
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        dateOfBirth: dateOfBirth.text.trim(),
        password: password.text.trim(),
      );

      if (!mounted) {
        return;
      }
      Navigator.pop(context);
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
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Register',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create new account with RedBox Digital Menu for free',
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall?.fontSize ??
                        20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                buildTextField(
                  controller: firstName,
                  context: context,
                  title: 'First name',
                  hintText: 'First name',
                ),

                buildTextField(
                  controller: lastName,
                  context: context,
                  title: 'Last name',
                  hintText: 'Last name',
                ),

                buildTextField(
                  controller: username,
                  context: context,
                  title: 'Username',
                  hintText: 'Username',
                ),

                buildTextField(
                  controller: email,
                  context: context,
                  title: 'Email',
                  hintText: 'Email',
                ),

                buildTextField(
                  controller: dateOfBirth,
                  context: context,
                  title: 'Date of birth',
                  hintText: 'yyyy-mm-dd',
                ),

                buildTextField(
                  controller: password,
                  context: context,
                  title: 'Password',
                  hintText: 'Password',
                  obscureText: passVisibility,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      passVisibility = !passVisibility;
                    }),
                    icon: Icon(
                      passVisibility ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),

                Text(
                  'Confirm password',
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.labelLarge?.fontSize ?? 14,
                  ),
                ),

                const SizedBox(height: 5),

                TextFormField(
                  
                  controller: conPassword,
                  obscureText: conVisibility,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        conVisibility = !conVisibility;
                      }),
                      icon: Icon(
                        conVisibility ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Confirm password is required';
                    }

                    if (value.trim() != password.text.trim()) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                const SizedBox(height: 10),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: handleRegister,

                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
