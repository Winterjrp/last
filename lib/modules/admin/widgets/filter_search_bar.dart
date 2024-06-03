import 'package:flutter/material.dart';
import 'package:last/constants/size.dart';

typedef SearchCallback = void Function({required String searchText});

class FilterSearchBar extends StatelessWidget {
  final SearchCallback onSearch;
  final TextEditingController searchTextEditingController;
  final String labelText;

  const FilterSearchBar({
    Key? key,
    required this.onSearch,
    required this.searchTextEditingController,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () {
        searchTextEditingController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: searchTextEditingController.text.length,
        );
      },
      onChanged: (searchText) {
        onSearch(searchText: searchText);
      },
      cursorColor: Colors.black,
      controller: searchTextEditingController,
      style: TextStyle(
        fontSize: headerInputTextFontSize,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: searchTextEditingController.text.isEmpty
                ? Colors.grey
                : Colors.black,
            width: searchTextEditingController.text.isEmpty ? 1 : 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        labelText: labelText,
        labelStyle:
            TextStyle(color: Colors.grey, fontSize: headerInputTextFontSize),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        isDense: true,
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.only(
          left: 15,
          top: 12,
          bottom: 12,
        ),
        suffixIcon: searchTextEditingController.text.isNotEmpty
            ? IconButton(
                hoverColor: Colors.transparent,
                onPressed: () {
                  searchTextEditingController.clear();
                  onSearch(searchText: '');
                },
                icon: Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              )
            : Container(
                margin: const EdgeInsets.only(right: 10),
                child: Transform.scale(
                  scale: 2.8,
                  child: const Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 10,
                  ),
                ),
              ),
      ),
    );
  }
}
