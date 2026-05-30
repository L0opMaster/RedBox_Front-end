import 'package:flutter/material.dart';
import 'package:front_redbox/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ListOfUser extends StatefulWidget {
  const ListOfUser({super.key});

  @override
  State<ListOfUser> createState() => _ListOfUserState();
}

class _ListOfUserState extends State<ListOfUser> {
  bool _fetch = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetch) {
      _fetch = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UserProvider>().fetchUser();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Users'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child) {
          if (value.isloading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (value.listUser.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: value.listUser.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final users = value.listUser[index];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),

                  // Avatar
                  // leading: CircleAvatar(
                  //   radius: 28,
                  //   backgroundColor: colorScheme.primaryContainer,
                  //   backgroundImage: (users.imageUrl != null)
                  //       ? NetworkImage(users.imageUrl)
                  //       : null,
                  //   child: (users.imageUrl == null)
                  //       ? const Icon(Icons.person, color: Colors.red)
                  //       : null,
                  // ),

                  // Name + username
                  title: Text(
                    '${users.firstName} ${users.lastName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(users.username),

                  // Status
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: users.active
                          ? Colors.green.withOpacity(0.15)
                          : Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      users.active ? 'ACTIVE' : 'OFF',
                      style: TextStyle(
                        color: users.active ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
