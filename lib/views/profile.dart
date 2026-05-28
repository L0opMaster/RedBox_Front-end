import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front_redbox/core/storage_service.dart';
import 'package:front_redbox/model/user.dart';
import 'package:front_redbox/provider/auth_provider.dart';
import 'package:front_redbox/provider/change_langue_provider.dart';
import 'package:front_redbox/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final userJson = await StorageService.getUser();
    if (userJson == null) return;

    setState(() {
      user = UserModel.fromJson(jsonDecode(userJson));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    final firstName = user?.firstName ?? '';
    final lastName = user?.lastName ?? '';
    final username = user?.username ?? '';
    final email = user?.email ?? '';
    final roles = user?.roles ?? [];

    return Scaffold(
      backgroundColor: color.background,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: color.primary,
        elevation: 2,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mobile Products', style: TextStyle(color: color.surface)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'User',
                  style: TextStyle(
                    fontSize: theme.textTheme.labelMedium?.fontSize ?? 12,
                    color: color.surface,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'ID: 01',
                  style: TextStyle(
                    fontSize: theme.textTheme.labelMedium?.fontSize ?? 12,
                    color: color.surface,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              color: color.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('P', style: TextStyle(color: color.surface)),
            ),
          ),
        ),
        actions: [
          Consumer<ChangeLangueProvider>(
            builder: (context, value, child) {
              value.loadLangue();
              bool isEng = value.isEnglish;
              // value.loadLangue;
              return Padding(
                padding: const EdgeInsets.all(13),
                child: Container(
                  decoration: BoxDecoration(
                    color: color.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      context.read<ChangeLangueProvider>().togglelanguage();
                    },
                    child: Text(
                      'KH | EN',
                      style: TextStyle(
                        fontSize: 12,
                        color: 
                            isEng? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: color.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      children: [
                        _badge(color, 'ID: 1024'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green,
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 3,
                                backgroundColor: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Active Account',
                                style: TextStyle(
                                  color: color.surface,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    left: 20,
                    bottom: -50,
                    child: Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        color: color.secondary,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          firstName.isNotEmpty ? firstName[0] : '',
                          style: TextStyle(
                            color: color.surface,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstName $lastName',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@$username',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _infoBox(
                      context,
                      'EMAIL ADDRESS',
                      Icons.email_outlined,
                      email,
                    ),
                    const SizedBox(width: 10),
                    _infoBox(
                      context,
                      'SYSTEM USERNAME',
                      Icons.person_2_outlined,
                      '@$username',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: color.onSurface, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.lock_outline, size: 15),
                                SizedBox(width: 5),
                                Text('ASSIGNED AUTHORITIES'),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: color.secondary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${roles.length}',
                                    style: TextStyle(color: color.primary),
                                  ),
                                  Text(
                                    'Roles',
                                    style: TextStyle(color: color.primary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        ...roles.map(
                          (role) => Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: color.secondary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              role.toString(),
                              style: TextStyle(
                                color: color.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _themeAndLogout(context, color),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(ColorScheme color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.primaryContainer.withOpacity(0.4),
      ),
      child: Text(text, style: TextStyle(color: color.surface, fontSize: 12)),
    );
  }

  Widget _infoBox(
    BuildContext context,
    String title,
    IconData icon,
    String value,
  ) {
    final color = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: color.onSurface),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(icon, size: 20, color: color.secondary),
                const SizedBox(width: 5),
                Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeAndLogout(BuildContext context, ColorScheme color) {
    final themeProvider = context.watch<ThemeProvider>();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: color.onSurface),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contrast Theme Mode',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    themeProvider.isLight
                        ? 'Currently: Light Theme'
                        : 'Currently: Dark Theme',
                  ),
                ],
              ),
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: themeProvider.isLight,
                  onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.logout_outlined,
                  size: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Authorization Session',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Mock OAuth Security Context'),
                  ],
                ),
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);

                        await Future.delayed(const Duration(seconds: 1));

                        await Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).logOut();
                        if (!context.mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (_) => false,
                        );
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Icon(
                          Icons.logout_outlined,
                          size: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(width: 10),
                        isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : SizedBox(
                                width: 40,
                                child: Text(
                                  'SIGN OUT',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
