import 'package:flutter/material.dart';
import 'package:front_redbox/provider/product_provider.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  final int userId;
  final String userName;

  const UserProductsScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    final userProducts = productProvider.allProducts
        .where((product) => product.user == userId)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("$userName's Products")),
      body: userProducts.isEmpty
          ? const Center(child: Text("No products found"))
          : ListView.builder(
              itemCount: userProducts.length,
              itemBuilder: (context, index) {
                final product = userProducts[index];

                return ListTile(
                  leading: Image.network(
                    product.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.englishName),
                  subtitle: Text("\$${product.price}"),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Created: ${product.createdAt?.substring(0, 10)}"),
                      Text("Updated: ${product.updatedAt?.substring(0, 10)}"),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
