import 'package:flutter/material.dart';
import 'package:front_redbox/views/add_product.dart';
import 'package:front_redbox/views/home_view.dart';
import 'package:front_redbox/views/menu_view.dart';
import 'package:front_redbox/views/profile.dart';

class OntapView extends StatefulWidget {
  const OntapView({super.key});

  @override
  State<OntapView> createState() => _OntapViewState();
}

class _OntapViewState extends State<OntapView> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [HomeView(), AddProduct(), Profile(), MenuView()],
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
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
        ],
      ),
      // appBar: AppBar(
      //   elevation: 2,
      //   automaticallyImplyLeading: false,
      //   // automaticallyImplyActions: false,
      //   // leading: IconButton(
      //   //   onPressed: () {
      //   //     Navigator.push(context, AppTransition.slide(const Profile()));
      //   //   },
      //   //   icon: Icon(Icons.person, size: 30),
      //   // ),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 10.0),
      //       child: SizedBox(
      //         height: 30,
      //         child: Image.asset('assets/images/logo.png', height: 30),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
