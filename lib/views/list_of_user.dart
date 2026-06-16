import 'package:flutter/material.dart';
import 'package:front_redbox/provider/myproduct_provider.dart';
import 'package:front_redbox/provider/product_provider.dart';
import 'package:front_redbox/provider/user_provider.dart';
import 'package:front_redbox/views/user_products_screen.dart';
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

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List of Users'),
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await context.read<ProductProvider>().getAllProduct();
          },
          child: Consumer<UserProvider>(
            builder: (context, value, child) {
              if (value.isloading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (value.listUser.isEmpty) {
                return const Center(child: Text("No users found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: value.listUser.length,
                itemBuilder: (context, index) {
                  final user = value.listUser[index];

                  final products = context.watch<ProductProvider>().allProducts;

                  final userProducts = products
                      .where((p) => p.user == user.id)
                      .toList();

                  final totalProducts = userProducts.length;

                  final activeProducts = userProducts
                      .where((p) => p.isActive)
                      .length;

                  final inactiveProducts = userProducts
                      .where((p) => !p.isActive)
                      .length;

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserProductsScreen(
                            userId: user.id,
                            userName: "${user.firstName} ${user.lastName}",
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  child: Text(
                                    user.firstName[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user.firstName} ${user.lastName}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        "@${user.username}",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: user.active
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    user.active ? "Active" : "Inactive",
                                    style: TextStyle(
                                      color: user.active
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 24),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.email_outlined,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(user.email)),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: user.roles.map<Widget>((
                                          role,
                                        ) {
                                          return Chip(
                                            label: Text(
                                              role.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Products: $totalProducts",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text("Active: $activeProducts"),
                                        Text("Inactive: $inactiveProducts"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
