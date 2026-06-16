import 'package:flutter/material.dart';
import 'package:front_redbox/provider/product_provider.dart';
import 'package:front_redbox/provider/user_provider.dart';
import 'package:front_redbox/views/list_of_admin_product.dart';
import 'package:front_redbox/views/list_of_user.dart';
import 'package:provider/provider.dart';

class TelemetryAdmin extends StatefulWidget {
  const TelemetryAdmin({super.key});

  @override
  State<TelemetryAdmin> createState() => _TelemetryAdminState();
}

class _TelemetryAdminState extends State<TelemetryAdmin> {
  bool _fetch = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetch) {
      _fetch = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UserProvider>().fetchUser();
        context.read<ProductProvider>().getAllProduct();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final adminproductLength = context.watch<ProductProvider>();
    final usersystem = context.watch<UserProvider>();

    final products = adminproductLength.allProducts;
    final users = usersystem.listUser;
    // no crash even if empty
    final totalProducts = products.length;
    final totalUsers = users.length;
    print('totalUsers $totalUsers');
    final inActivePro = products.where((p) => p.isActive == false).length;
    final activeProducts = products.where((p) => p.isActive == true).length;

    final totalPrice = products.fold<double>(
      0,
      (sum, item) => sum + (item.price ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: const Text('TelemetryAdmin'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo.png',
              scale: 2,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ProductProvider>().getAllProduct();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListOfUser()),
                  );
                },
                child: _buildCard(
                  context,
                  title: 'Total User',
                  value: totalUsers.toString(),
                  subtitle: 'All user using in system',
                  icon: Icons.people,
                  isButtom: true,
                ),
              ),
              _buildCard(
                context,
                title: 'Total Products',
                value: totalProducts.toString(),
                subtitle: 'All products in system',
                icon: Icons.inventory_2_rounded,
              ),

              // const SizedBox(height: 16),
              _buildCard(
                context,
                title: 'Active Products',
                value: activeProducts.toString(),
                subtitle: 'Products currently active',
                icon: Icons.check_circle,
              ),

              // const SizedBox(height: 16),
              _buildCard(
                context,
                title: 'Inctive Products',
                value: inActivePro.toString(),
                subtitle: 'Products currently active',
                icon: Icons.cancel_outlined,
              ),

              // const SizedBox(height: 16),
              _buildCard(
                context,
                title: 'Total Price',
                value: '\$${totalPrice.toStringAsFixed(2)}',
                subtitle: 'Total amount of all products',
                icon: Icons.attach_money_rounded,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListOfAdminProduct(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list),
                  label: const Text(
                    'View Product List',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    bool isButtom = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isButtom
                    ? colorScheme.primaryContainer
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: colorScheme.primary, size: 32),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    value,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
