import 'package:flutter/material.dart';
import 'package:front_redbox/model/myproductpage.dart';
import 'package:front_redbox/provider/myproduct_provider.dart';
import 'package:provider/provider.dart';

class DeletedDialog extends StatelessWidget {
  final MyProduct product;

  const DeletedDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Product"),
      content: Text(
        'Are you sure you want to delete "${product.englishName}" ?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            final provider = context.read<MyproductProvider>();

            final success = await provider.deletedMyProduct(product.id);
            print(provider.errorMessage);

            if (!context.mounted) return;

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success
                      ? "Product deleted successfully"
                      : provider.errorMessage ?? "Delete failed",
                ),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          },
          child: Text(
            "Delete",
            style: TextStyle(color: Theme.of(context).colorScheme.surface),
          ),
        ),
      ],
    );
  }
}
