import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

typedef UpdateValueCallbackFunction = void Function({required String value});

class CustomDropdown extends StatelessWidget {
  final Color primaryColor;
  final bool isCreate;
  final String value;
  final String searchText;
  final double inputTextSize;
  final double labelTextSize;
  final List<String> choiceItemList;
  final UpdateValueCallbackFunction updateValueCallback;
  const CustomDropdown({
    required this.primaryColor,
    required this.isCreate,
    required this.value,
    required this.inputTextSize,
    required this.labelTextSize,
    required this.choiceItemList,
    required this.updateValueCallback,
    Key? key,
    required this.searchText,
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
            backgroundColor: const Color.fromRGBO(254, 245, 245, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        showSelectedItems: true,
        searchFieldProps: const TextFieldProps(
            decoration: InputDecoration(
          floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            height: 0.9,
          ),
          filled: true,
          fillColor: Colors.white,
        )),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: TextStyle(fontSize: inputTextSize),
          dropdownSearchDecoration: InputDecoration(
            floatingLabelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              height: 0.9,
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: searchText,
            hintStyle: TextStyle(fontSize: labelTextSize),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
          )),
      items: choiceItemList,
      onChanged: (val) {
        updateValueCallback(value: val!);
      },
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
                    style: const TextStyle(fontSize: 16, color: Colors.black),
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
                          color: Color.fromRGBO(202, 102, 108, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.pets,
                        color: Color.fromRGBO(202, 102, 108, 1))
                  ],
                ),
        ],
      ),
    );
  }
}
