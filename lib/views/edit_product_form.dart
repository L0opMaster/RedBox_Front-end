import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:front_redbox/model/category.dart';
import 'package:front_redbox/model/myproductpage.dart';
import 'package:front_redbox/provider/category_provider.dart';
import 'package:front_redbox/provider/change_langue_provider.dart';
import 'package:front_redbox/provider/myproduct_provider.dart';
import 'package:front_redbox/provider/product_provider.dart';
import 'package:provider/provider.dart';

class EditProductForm extends StatefulWidget {
  final MyProduct product;
  const EditProductForm({super.key, required this.product});

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController khmerNameController = TextEditingController();

  final TextEditingController englishNameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController imageUrlController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  bool isActive = true;

  final _categoryNoti = ValueNotifier<String?>(null);

  final _activeNoti = ValueNotifier<bool>(true);

  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    khmerNameController.text = product.khmerName;
    englishNameController.text = product.englishName;
    descriptionController.text = product.description;
    imageUrlController.text = product.imageUrl;
    priceController.text = product.price.toString();

    isActive = product.isActive;

    // // set category
    _categoryNoti.value = product.category.toString();
    selectedCategoryId = product.category;

    Future.microtask(() {
      context.read<CategoryProvider>().fetchCategory();
    });
  }

  @override
  void dispose() {
    _categoryNoti.dispose();
    khmerNameController.dispose();
    englishNameController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildBody() {
    final body = <String, dynamic>{
      'khmerName': khmerNameController.text.trim(),
      'englishName': englishNameController.text.trim(),
      'description': descriptionController.text.trim(),
      'imageUrl': imageUrlController.text.trim(),
      'isActive': isActive,
      'price': priceController.text.trim(),
      'categoryId': int.parse(_categoryNoti.value!),
    };
    return body;
  }

  void _showSnackBar(String message, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle()),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    final khmerName = khmerNameController.text;
    if (khmerName.isEmpty) {
      _showSnackBar('សូមបំពេញឈ្មោះផលិតផល (Khmer)', success: false);
      return;
    }

    if (englishNameController.text.trim().isEmpty) {
      _showSnackBar('សូមបំពេញឈ្មោះផលិតផល (English)', success: false);
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      _showSnackBar('សូមបំពេញការពិពរណ៏នា', success: false);
      return;
    }

    if (imageUrlController.text.trim().isEmpty) {
      _showSnackBar('បញ្ចូល code url', success: false);
      return;
    }

    if (priceController.text.trim().isEmpty) {
      _showSnackBar('បញ្ចូលតម្លៃ', success: false);
      return;
    }

    if (_categoryNoti.value == null) {
      _showSnackBar('ជ្រើសរើស​ប្រភេទ', success: false);
      return;
    }
    final body = _buildBody();
    final provider = context.read<MyproductProvider>();

    bool success = await provider.updateProduct(widget.product.id, body);

    if (!mounted) return;

    if (success) {
      _showSnackBar('បានកែប្រែផលិតផលបានជោគជ័យ');
      Navigator.pop(context);
    } else {
      _showSnackBar(
        provider.errorMessage ?? 'មានកំហុស សូមព្យាយាមម្តងទៀត',
        success: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final isEng = context.read<ChangeLangueProvider>().isEnglish;
    final categories = categoryProvider.categories;

    return Scaffold(
      appBar: AppBar(title: Text(isEng ? "Update Product" : "កែប្រែផលិតផល")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              /// Khmer Name
              TextFormField(
                controller: khmerNameController,
                decoration: InputDecoration(
                  labelText: isEng ? "Khmer Name" : "ឈ្មោះជាភាសាខ្មែរ",
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isEng
                        ? "khmer_name is required"
                        : "សូមបញ្ចូលឈ្មោះជាភាសាខ្មែរ";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// English Name
              TextFormField(
                controller: englishNameController,
                decoration: InputDecoration(
                  labelText: isEng ? "English Name" : "ឈ្មោះជាភាសាអង់គ្លេស",
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isEng
                        ? "english_name is required"
                        : "សូមបញ្ចូលឈ្មោះជាភាសាអង់គ្លេស";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// Description
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: isEng ? "Description" : "ការពិពណ៌នា",
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// Image URL
              TextFormField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  labelText: isEng ? "Image URL" : "តំណរូបភាព",
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isEng
                        ? "image_url is required"
                        : "សូមបញ្ចូលតំណរូបភាព";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// Price
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isEng ? "Price" : "តម្លៃ",
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isEng ? "price is required" : "សូមបញ្ចូលតម្លៃ";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// Category Dropdown
              Consumer<CategoryProvider>(
                builder: (context, value, child) {
                  final categories = value.categories
                      .where((c) => c.id != 0)
                      .toList();

                  if (value.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        isEng ? 'Category' : 'ជ្រើសរើសប្រភេទ',
                        style: const TextStyle(fontSize: 13),
                      ),
                      valueListenable: _categoryNoti,
                      items: categories
                          .map(
                            (category) => DropdownItem<String>(
                              value: category.id.toString(),
                              child: Text(
                                isEng
                                    ? category.englishName
                                    : category.khmerName,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        _categoryNoti.value = value;
                        selectedCategoryId = int.parse(value!);
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              /// Active Switch
              SwitchListTile(
                title: Text(isEng ? "Is Active" : "សកម្ម"),
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  _submitForm();
                },

                child: Text(
                  isEng ? "Submit" : "បញ្ជូន",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
