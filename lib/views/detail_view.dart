import 'package:flutter/material.dart';
import 'package:front_redbox/model/product_page.dart';
import 'package:front_redbox/provider/change_langue_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class DetailView extends StatefulWidget {
  final Product product;
  const DetailView({super.key, required this.product});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  Product get product => widget.product;
  @override
  Widget build(BuildContext context) {
    final isEng = context.watch<ChangeLangueProvider>().isEnglish;
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(isEng ? product.englishName : product.khmerName),
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
        primary: true,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize
                    .min, // Prevents Column from taking infinite height
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: Image.network(
                          '${product.imageUrl}',
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.image_not_supported),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),

                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: product.isActive ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product.isActive ? "Active" : "Out",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // ================= PRODUCT CODE (BOTTOM LEFT) =================
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            product.productCode,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      12.0,
                    ), // Slightly adjusted padding
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              isEng ? product.englishName : product.khmerName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${product.price} \$",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Text(
                          isEng ? 'Description :' : 'ពិពរណ៍នា :',
                          style: TextStyle(
                            fontSize: 18,

                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              product.description,
                              style: TextStyle(fontSize: 16),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              isEng ? 'Contact :' : 'ទំនាក់ទំនង :',
                              style: TextStyle(
                                fontSize: 18,

                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(width: 50),
                            Expanded(
                              child: SizedBox(
                                child: Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Icon(Icons.facebook),
                                    Icon(Icons.telegram),
                                    Icon(Icons.snapchat), // Option 1: Snapchat
                                    Icon(Icons.wechat), // Option 2: WeChat
                                    Icon(Icons.reddit), // Option 3: Reddit
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
