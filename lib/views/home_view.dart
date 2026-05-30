import 'package:flutter/material.dart';
import 'package:front_redbox/provider/category_provider.dart';
import 'package:front_redbox/provider/change_langue_provider.dart';
import 'package:front_redbox/provider/product_provider.dart';
import 'package:front_redbox/views/detail_view.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _fetched = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      _fetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductProvider>().fetchProduct();
        context.read<CategoryProvider>().fetchCategory();
        // context.read<CustomerProvider>().fetchCustomers(refresh: true);
      });
    }
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

  // void _showSnackBar(String message, {bool success = true}) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         message,
  //         style: TextStyle(color: Theme.of(context).colorScheme.error),
  //       ),
  //       backgroundColor: success
  //           ? Colors.green
  //           : Theme.of(context).colorScheme.surface,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final isEng = context.read<ChangeLangueProvider>().isEnglish;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    // ================= ANIMATED SEARCH CONTAINER =================
                    // If searching, let it expand to take all space. If not, it falls back to 42.
                    _isSearching
                        ? Expanded(
                            child: TextField(
                              onChanged: (value) {
                                context.read<ProductProvider>().search(value);
                              },
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              decoration: InputDecoration(
                                hintText:
                                    context
                                        .watch<ChangeLangueProvider>()
                                        .isEnglish
                                    ? 'Search menus...'
                                    : 'ស្វែងរកមុខម្ហូប...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 22,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                // contentPadding: const EdgeInsets.symmetric(
                                //   // vertical: 10,
                                // ),
                              ),
                            ),
                          )
                        : Consumer<CategoryProvider>(
                            builder: (context, value, child) {
                              if (value.isLoading) {
                                return _buildSearchSkele();
                              }

                              if (value.categories.isEmpty) {
                                return SizedBox.shrink();
                              }
                              return Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isSearching = true;
                                    });
                                    _searchFocusNode.requestFocus();
                                  },
                                  borderRadius: BorderRadius.circular(25),
                                  child: Icon(
                                    Icons.search,
                                    size: 20,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              );
                            },
                          ),

                    if (!_isSearching) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Consumer<CategoryProvider>(
                          builder: (context, provider, child) {
                            if (provider.isLoading) {
                              return _buildCategorySkelenorizer();
                            }
                            if (provider.categories.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return SizedBox(
                              height: 36,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.categories.length,
                                itemBuilder: (context, index) {
                                  final category = provider.categories[index];
                                  final isEng = context
                                      .watch<ChangeLangueProvider>()
                                      .isEnglish;
                                  final isSelected =
                                      provider.selectedCategoryId ==
                                      category.id;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        provider.setSelectedCategory(
                                          category.id,
                                        );
                                        context
                                            .read<ProductProvider>()
                                            .fetchProduct(
                                              refresh: true,
                                              categoryId: category.id == 0
                                                  ? null
                                                  : category.id,
                                            );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                              : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
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
                                                  ? Theme.of(
                                                      context,
                                                    ).colorScheme.onPrimary
                                                  : Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
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
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 15),

            //PRODUCT GRID
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, value, child) {
                  if (value.isLoading) {
                    return _buildProCardSkelenorizer();
                  }
                  if (value.products.isEmpty) {
                    return Center(
                      child: Text(
                        isEng ? 'Product not found' : 'មិនមាន​ ឬរកមិនឃើញ',
                      ),
                    );
                  }
                  return RefreshIndicator(
                    displacement: 10,
                    onRefresh: () async {
                      await context.read<ProductProvider>().fetchProduct(
                        refresh: true,
                      );
                    },
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: value.products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) {
                        final product = value.products[index];
                        final isEng = context
                            .watch<ChangeLangueProvider>()
                            .isEnglish;
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailView(product: product),
                            ),
                          ),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ================= IMAGE =================
                                Stack(
                                  children: [
                                    Container(
                                      height: 130,
                                      width: double.infinity,
                                      color: Colors.grey.shade300,
                                      child: Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.fill,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                ),
                                              );
                                            },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    //ACTIVE
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: product.isActive
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // ================= PRODUCT INFO =================
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isEng
                                              ? product.englishName
                                              : product.khmerName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text("${product.price}\$"),
                                      ],
                                    ),
                                  ),
                                ),
                                // if (value.isLoading && value.products.isNotEmpty)
                                //   _buildProCardSkelenorizer(),
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

  AppBar _buildAppBar(BuildContext context) {
    final isEng = context.watch<ChangeLangueProvider>().isEnglish;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(isEng ? 'Home' : 'ទំព័រដើម'),
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
    );
  }

  Widget _buildSearchSkele() {
    return Skeletonizer(
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1.5),
        ),
        child: Icon(Icons.search, size: 20),
      ),
    );
  }

  Widget _buildProCardSkelenorizer() {
    return Skeletonizer(
      child: GridView.builder(
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= IMAGE =================
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 40),
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
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    // Positioned(
                    //   bottom: 8,
                    //   left: 8,
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 10,
                    //       vertical: 5,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: Colors.black.withOpacity(0.6),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: const Text(
                    //       "CODE: P001",
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 11,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),

                //PRODUCT INFO
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text("\$10.00"),
                    ],
                  ),
                ),
              ],
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
      containersColor: Theme.of(context).colorScheme.surface,
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
