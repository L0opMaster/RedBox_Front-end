import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_redbox/core/storage_service.dart';
import 'package:front_redbox/model/user.dart';
import 'package:front_redbox/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  UserModel? user;

  Future<void> loadUser() async {
    final userJson = await StorageService.getUser();

    if (userJson != null) {
      setState(() {
        user = UserModel.fromJson(jsonDecode(userJson));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mobile Products',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
            Row(
              mainAxisSize: .min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User',
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.labelMedium?.fontSize ?? 12,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'ID: 01',
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.labelMedium?.fontSize ?? 12,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                'P',
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextButton(
                onPressed: () {},
                child: Text('KH | EN', style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Header Background
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),

                    // Top Badges
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withOpacity(0.4),
                            ),
                            child: Text(
                              'ID: 1024',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                                fontSize: 12,
                              ),
                            ),
                          ),

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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Floating Avatar
                    Positioned(
                      left: 20,
                      bottom: -50,
                      child: Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
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
                            'P',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
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
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user?.firstName ?? ''}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@sothy.dev',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Container(
                        width: 130,
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'EMAIL ADDRESS',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 20,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'sothy1223@gmail.com',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 130,
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'SYSTEM USERNAME',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_2_outlined,
                                    size: 20,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      '@username',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });

                          // show loading for 1 second
                          await Future.delayed(const Duration(seconds: 1));

                          await Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          ).logOut();

                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Log out"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
