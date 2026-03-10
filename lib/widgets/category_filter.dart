import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/listing_provider.dart';
import '../utils/constants.dart';

class CategoryFilter extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategoryFilter({
    Key? key,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ListingProvider>(
      builder: (context, listingProvider, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildChip('All', listingProvider),
              ...Constants.categories.map((c) => _buildChip(c, listingProvider)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String category, ListingProvider listingProvider) {
    final isSelected = listingProvider.selectedCategory == category;
    final count = listingProvider.getCountForCategory(category);
    final label = category == 'All' ? 'All' : '$category $count'.trim();

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Material(
        color: isSelected
            ? const Color(0xFF1A237E)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => widget.onCategorySelected(category),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
