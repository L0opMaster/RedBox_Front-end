import 'package:flutter/material.dart';
import 'package:front_redbox/provider/category_provider.dart';
import 'package:front_redbox/provider/change_langue_provider.dart';
import 'package:front_redbox/provider/myproduct_provider.dart';
import 'package:front_redbox/provider/product_provider.dart';
import 'package:front_redbox/views/deleted_dialog.dart';
import 'package:front_redbox/views/edit_product_form.dart';
import 'package:front_redbox/views/product_form.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListOfAdminProduct extends StatefulWidget {
  const ListOfAdminProduct({super.key});

  @override
  State<ListOfAdminProduct> createState() => _ListOfAdminProductState();
}

class _ListOfAdminProductState extends State<ListOfAdminProduct> {
  bool _fetch = false;
  bool _isSearching = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetch) {
      _fetch = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductProvider>().fetchProduct();
        context.read<CategoryProvider>().fetchCategory();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
  }

  void _onScroll() {
    final provider = context.read<ProductProvider>();

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!provider.isLoading && provider.hasMore) {
        provider.fetchProduct();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEng = context.read<ChangeLangueProvider>().isEnglish;

    return Scaffold(
      appBar: AppBar(title: Text(isEng ? 'Product' : 'បញ្ជីផលិតផល')),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      context.read<ProductProvider>().search(value);
                    },
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: context.watch<ChangeLangueProvider>().isEnglish
                          ? 'Search menus...'
                          : 'ស្វែងរកមុខម្ហូប...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 22,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();

                            _isSearching = false;
                          });
                          _searchFocusNode.unfocus();

                          context.read<ProductProvider>().search('');
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      // contentPadding: const EdgeInsets.symmetric(
                      //   // vertical: 10,
                      // ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                IconButton.filled(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductForm()),
                    );
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Consumer<CategoryProvider>(
              builder: (context, value, child) {
                if (value.isLoading) return _buildCategorySkelenorizer();
                if (value.categories.isEmpty) {
                  return SizedBox.shrink();
                }
                return SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: value.categories.length,
                    itemBuilder: (context, index) {
                      final category = value.categories[index];
                      final isEng = context
                          .watch<ChangeLangueProvider>()
                          .isEnglish;
                      final isSelected =
                          value.selectedCategoryId == category.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {
                            value.setSelectedCategory(category.id);
                            context.read<ProductProvider>().fetchProduct(
                              refresh: true,
                              categoryId: category.id == 0 ? null : category.id,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary
                                    // ignore: deprecated_member_use
                                    .withOpacity(0.5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                isEng
                                    ? category.englishName
                                    : category.khmerName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            // title
            Text(
              isEng ? 'Products' : 'ផលិតផល',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            // Product list
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, value, child) {
                  if (value.isLoading) return _buildMyProductSkelenorizer();
                  if (value.products.isEmpty) return SizedBox.shrink();
                  return RefreshIndicator(
                    displacement: 10,
                    onRefresh: () async {
                      await context.read<MyproductProvider>().fetchMyProducts(
                        refresh: true,
                      );
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: value.products.length,
                      itemBuilder: (context, index) {
                        final product = value.products[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    product.imageUrl,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,

                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 90,
                                              height: 90,
                                              color: Colors.grey.shade200,
                                              child: const Icon(
                                                Icons.broken_image,
                                              ),
                                            ),

                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }

                                          return SizedBox(
                                            width: 90,
                                            height: 90,
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // =============== PRODUCT INFO ===============
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isEng
                                            ? product.englishName
                                            : product.khmerName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        '${isEng ? 'Price' : 'តម្លៃ'} : \$${product.price}',
                                        style: TextStyle(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.8),
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      // ================= CATEGORY =================
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: Text(
                                          '${isEng ? 'Category' : 'ប្រភេទ'} : ${product.category}',
                                          style: TextStyle(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 14),
                                    ],
                                  ),
                                ),
                                // Column(
                                //   children: [
                                //     IconButton.outlined(
                                //       onPressed: () {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (context) =>
                                //                 EditProductForm(
                                //                   product: product,
                                //                 ),
                                //           ),
                                //         );
                                //       },
                                //       icon: Icon(Icons.edit),
                                //     ),
                                //     IconButton.filled(
                                //       onPressed: () {
                                //         showDialog(
                                //           context: context,
                                //           builder: (context) {
                                //             return DeletedDialog(
                                //               product: product,
                                //             );
                                //           },
                                //         );
                                //       },
                                //       icon: Icon(Icons.delete),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyProductSkelenorizer() {
    return Skeletonizer(
      enabled: true, // Ensures the skeleton effect is active
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =============== IMAGE PLACEHOLDER ===============
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 90,
                      height: 90,
                      color: Colors
                          .white, // Skeletonizer will mask this automatically
                    ),
                  ),

                  const SizedBox(width: 14),

                  // =============== PRODUCT INFO ===============
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Product Name Placeholder',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text('Category / ប្រភេទ : Food & Drinks'),

                        const SizedBox(height: 6),

                        // ================= CATEGORY BADGE =================
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Removed amber; lets skeleton color take over
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            'Category / ប្រភេទ',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),

                        const SizedBox(height: 14),
                      ],
                    ),
                  ),

                  // =============== ACTIONS ===============
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySkelenorizer() {
    return Skeletonizer(
      effect: ShimmerEffect(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        duration: const Duration(milliseconds: 1200),
      ),
      child: SizedBox(
        height: 30,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueGrey),
                ),
                child: Center(child: Text("Category $index")),
              ),
            );
          },
        ),
      ),
    );
  }
}
