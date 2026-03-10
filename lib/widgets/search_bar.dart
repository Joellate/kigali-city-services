import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String hintText;

  const SearchBar({
    Key? key,
    required this.onSearch,
    this.hintText = 'Search for a service',
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  widget.onSearch('');
                  setState(() {});
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onChanged: (value) {
        widget.onSearch(value);
        setState(() {});
      },
    );
  }
}
