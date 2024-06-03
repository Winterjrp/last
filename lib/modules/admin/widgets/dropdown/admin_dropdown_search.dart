import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';

typedef UpdateValueCallbackFunction = void Function({required String value});

class AdminCustomDropdownSearch extends StatelessWidget {
  final Color primaryColor;
  final bool isCreate;
  final String value;
  final double labelTextSize;
  final List<String> choiceItemList;
  final UpdateValueCallbackFunction updateValueCallback;
  const AdminCustomDropdownSearch({
    required this.primaryColor,
    required this.isCreate,
    required this.value,
    required this.labelTextSize,
    required this.choiceItemList,
    required this.updateValueCallback,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      dropdownButtonProps: DropdownButtonProps(
        color: primaryColor,
      ),
      selectedItem: isCreate ? null : value,
      popupProps: PopupProps.menu(
        itemBuilder: (BuildContext context, String item, bool isSelect) {
          return _itemForm(item);
        },
        menuProps: MenuProps(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        showSearchBox: true,
        showSelectedItems: true,
        searchFieldProps: TextFieldProps(
          style: const TextStyle(fontSize: headerInputTextFontSize),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            floatingLabelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              height: 0.9,
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.search, color: primaryColor),
            labelText: "ค้นหาชนิดสัตว์เลี้ยง",
            labelStyle: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
          ),
        ),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: const TextStyle(fontSize: headerInputTextFontSize),
        dropdownSearchDecoration: InputDecoration(
          prefixIconConstraints: const BoxConstraints(
            minWidth: 15,
          ),
          prefixIcon: _searchTextPrefixWord(),
          fillColor: Colors.white,
          filled: true,
          labelText: "ชนิดสัตว์เลี้ยง",
          labelStyle: TextStyle(
              fontSize: labelTextSize,
              color: Colors.grey,
              fontWeight: FontWeight.bold),
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
                color: value == "" ? Colors.red : Colors.black,
                width: value == "" ? 1.2 : 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
      items: choiceItemList,
      onChanged: (val) {
        updateValueCallback(value: val!);
      },
    );
  }

  Container _searchTextPrefixWord() {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: value != ""
          ? const SizedBox()
          : const MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: [
                  Text(
                    " ชนิดสัตว์เลี้ยง",
                    style: TextStyle(color: Colors.grey, fontSize: 19),
                  ),
                  Text(
                    "*",
                    style: TextStyle(color: Colors.red, fontSize: 19),
                  ),
                ],
              ),
            ),
    );
  }

  Padding _itemForm(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item != value
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              : Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 16,
                          color: darkFlesh,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.pets, color: darkFlesh, size: 18)
                  ],
                ),
        ],
      ),
    );
  }
}
