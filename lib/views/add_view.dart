import 'package:flutter/material.dart';
import 'package:front_redbox/provider/change_langue_provider.dart';
import 'package:front_redbox/views/product_form.dart';
import 'package:provider/provider.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEng = context.read<ChangeLangueProvider>().isEnglish;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: Text(
          isEng ? 'Home' : 'ទំព័រដើម',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Image.asset(
              'assets/images/logo.png',
              scale: 2,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Badge / Tag Section
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: theme.colorScheme.primary.withOpacity(0.1),
                    ),
                    child: Text(
                      isEng ? 'Deploy Instant' : 'ដំណើរការភ្លាមៗ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Header Titles
                Text(
                  isEng
                      ? 'Register New Product'
                      : 'ចុះបញ្ជីផលិតផលថ្មី',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isEng ? 'Try it out' : 'សាកល្បងប្រើប្រាស់',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),

                // Requirements Callout Box
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.error.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isEng
                                ? 'Required Fields:'
                                : 'ព័ត៌មានដែលត្រូវបំពេញ៖',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildBulletPoint(
                        theme,
                        isEng
                            ? 'English name is required'
                            : 'ត្រូវបញ្ចូលឈ្មោះជាភាសាអង់គ្លេស',
                      ),
                      _buildBulletPoint(
                        theme,
                        isEng
                            ? 'Khmer name is required'
                            : 'ត្រូវបញ្ចូលឈ្មោះជាភាសាខ្មែរ',
                      ),
                      _buildBulletPoint(
                        theme,
                        isEng
                            ? 'Price must be a positive number'
                            : 'តម្លៃត្រូវតែជាលេខវិជ្ជមាន',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Description Text
                Text(
                  isEng
                      ? 'Use the native bottom sheets or click below to launch the modal form!'
                      : 'ប្រើ Bottom Sheet ឬចុចប៊ូតុងខាងក្រោមដើម្បីបើក Form!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // Action Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductForm(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_box_rounded),
                  label: Text(isEng ? 'Open Form' : 'បើក Form'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
      child: Row(
        children: [
          Icon(Icons.brightness_1, size: 6, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}