import 'package:flutter/material.dart';
import 'package:front_redbox/provider/myproduct_provider.dart';
import 'package:front_redbox/views/list_of_product.dart';
import 'package:provider/provider.dart';

class Telemetry extends StatefulWidget {
  const Telemetry({super.key});

  @override
  State<Telemetry> createState() => _TelemetryState();
}

class _TelemetryState extends State<Telemetry> {
  bool _fetch = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetch) {
      _fetch = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MyproductProvider>().gatAllMyPro();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final myProductProvider = context.watch<MyproductProvider>();

    final products = myProductProvider.allMyProducts;

    // no crash even if empty
    final totalProducts = products.length;
    final inactiveProducts = products.where((p) => p.isActive == false).length;

    final activeProducts = products.where((p) => p.isActive == true).length;

    final totalPrice = products.fold<double>(
      0,
      (sum, item) => sum + (item.price ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: const Text('Telemetry'),
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              context,
              title: 'Total Products',
              value: totalProducts.toString(),
              subtitle: 'All products in system',
              icon: Icons.inventory_2_rounded,
            ),

            const SizedBox(height: 16),

            _buildCard(
              context,
              title: 'Active Products',
              value: activeProducts.toString(),
              subtitle: 'Products currently active',
              icon: Icons.check_circle,
            ),
            const SizedBox(height: 16),

            _buildCard(
              context,
              title: 'Inactive Products',
              value: inactiveProducts.toString(),
              subtitle: 'Products currently inactive',
              icon: Icons.cancel_rounded,
            ),

            const SizedBox(height: 16),

            const SizedBox(height: 16),

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
                      builder: (context) => const ListOfProduct(),
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
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
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
                color: colorScheme.primaryContainer,
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
