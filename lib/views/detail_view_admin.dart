import 'package:flutter/material.dart';
import 'package:front_redbox/model/product_page.dart';
import 'package:front_redbox/provider/change_langue_provider.dart';
import 'package:front_redbox/provider/user_provider.dart';
import 'package:front_redbox/util/uri_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class DetailViewAdmin extends StatefulWidget {
  final Product product;
  const DetailViewAdmin({super.key, required this.product});

  @override
  State<DetailViewAdmin> createState() => _DetailViewAdminState();
}

class _DetailViewAdminState extends State<DetailViewAdmin> {
  Product get product => widget.product;
  final urlLauncher = UriLauncher();
  @override
  Widget build(BuildContext context) {
    final isEng = context.watch<ChangeLangueProvider>().isEnglish;
    final userProvider = context.watch<UserProvider>();

    final owner = userProvider.getUserById(product.user);
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
                          product.imageUrl,
                          fit: BoxFit.cover,
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
                            fontWeight: FontWeight.bold,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isEng ? 'Contact :' : 'ទំនាក់ទំនង :',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Wrap buttons in an Expanded block to prevent overflow across varied screen sizes
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // 1. Phone Call
                                  IconButton(
                                    onPressed: () =>
                                        urlLauncher.open("tel:+85516474665"),
                                    icon: const Icon(
                                      Icons.phone,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'Call Support',
                                  ),

                                  // 2. Telegram Chat
                                  IconButton(
                                    onPressed: () => urlLauncher.open(
                                      "https://t.me/Kan_socheata",
                                    ),
                                    icon: const Icon(
                                      Icons.telegram,
                                      color: Colors.blue,
                                    ),
                                    tooltip: 'Telegram',
                                  ),

                                  // 3. Snapchat (Example Link Configuration)
                                  IconButton(
                                    onPressed: () => urlLauncher.open(
                                      "https://www.facebook.com/nobodyinurLife",
                                    ),
                                    icon: const Icon(
                                      Icons.facebook,
                                      color: Colors.blue,
                                    ),
                                    tooltip: 'Snapchat',
                                  ),

                                  // 4. WeChat (Typically launched via direct deep link or web page fallback)
                                  IconButton(
                                    onPressed: () => urlLauncher.open(
                                      "https://www.tiktok.com/@async_21?lang=en",
                                    ),
                                    icon: const Icon(
                                      Icons.tiktok,
                                      color: Colors.black,
                                    ),
                                    tooltip: 'WeChat',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isEng ? 'Store Location:' : 'មជ្ឈមណ្ឌលគាំទ្រ :',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () => urlLauncher.open(
                                  "https://www.google.com/maps/place/Norton+University/@11.5873433,104.9295021,17z/data=!4m6!3m5!1s0x310953fd9f9a51e9:0xc26eafcd2ed5ca29!8m2!3d11.5881108!4d104.9301205!16s%2Fm%2F04jbf6t?entry=ttu&g_ep=EgoyMDI2MDYwMS4wIKXMDSoASAFQAw%3D%3D",
                                ),
                                label: Text(
                                  'Norton University',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                icon: Icon(Icons.pin_drop_outlined),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              'Owner :',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(owner?.firstName ?? 'Unknown'),
                                SizedBox(width: 10),
                                Text(owner?.lastName ?? 'Unknow'),
                              ],
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
