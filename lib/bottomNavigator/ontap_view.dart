import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_redbox/core/storage_service.dart';
import 'package:front_redbox/model/user.dart';
import 'package:front_redbox/views/add_view.dart';
import 'package:front_redbox/views/home_view.dart';
import 'package:front_redbox/views/telemetry.dart';
import 'package:front_redbox/views/profile.dart';
import 'package:front_redbox/views/telemetry_admin.dart';

class OntapView extends StatefulWidget {
  const OntapView({super.key});

  @override
  State<OntapView> createState() => _OntapViewState();
}

class _OntapViewState extends State<OntapView> {
  UserModel? user;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final userJson = await StorageService.getUser();

    if (userJson == null) {
      return;
    }

    setState(() {
      user = UserModel.fromJson(jsonDecode(userJson));
    });
  }

  @override
  Widget build(BuildContext context) {
    final roles = user?.roles ?? [];
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeView(),
          AddView(),
          Profile(),
          roles.contains("ROLE_ADMIN") ? TelemetryAdmin() : Telemetry(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => setState(() {
          _currentIndex = value;
        }),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: "Telemetry",
          ),
        ],
      ),
    );
  }
}
