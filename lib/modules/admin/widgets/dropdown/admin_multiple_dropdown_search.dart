import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

typedef UpdateValueCallbackFunction = void Function(
    {required List<String> value});

class AdminCustomMultipleDropdownSearch extends StatelessWidget {
  final Color primaryColor;
  final bool isCreate;
  final List<String> value;
  final List<String> choiceItemList;
  final double labelTextSize;
  final String hintText;
  final String searchText;
  final UpdateValueCallbackFunction updateValueCallback;
  final GlobalKey<DropdownSearchState<String>> dropdownKey;
  const AdminCustomMultipleDropdownSearch(
      {required this.primaryColor,
      required this.isCreate,
      required this.value,
      required this.choiceItemList,
      required this.labelTextSize,
      required this.searchText,
      required this.hintText,
      required this.updateValueCallback,
      required this.dropdownKey,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>.multiSelection(
      dropdownButtonProps: DropdownButtonProps(
        color: primaryColor,
      ),
      selectedItems: isCreate ? [] : value,
      key: dropdownKey,
      popupProps: PopupPropsMultiSelection.menu(
        selectionWidget: (BuildContext context, String temp, bool isCheck) {
          return Checkbox(
            activeColor: primaryColor,
            value: isCheck,
            onChanged: (bool? value) {},
          );
        },
        menuProps: MenuProps(
            backgroundColor: const Color.fromRGBO(254, 245, 245, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        validationWidgetBuilder: (ctx, selectedItems) {
          return Container(
            height: 80,
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(right: 5, bottom: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                dropdownKey.currentState?.popupOnValidate();
              },
            ),
          );
        },
        itemBuilder: (BuildContext context, String item, bool isSelect) {
          return _itemForm(item, isSelect);
        },
        showSearchBox: true,
        showSelectedItems: true,
        searchFieldProps: TextFieldProps(
          cursorColor: Colors.black,
          decoration: InputDecoration(
            floatingLabelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              height: 0.9,
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.search, color: primaryColor),
            labelText: searchText,
            labelStyle: const TextStyle(fontSize: 16, height: 1),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ),
      dropdownBuilder: (BuildContext context, List<String> selectedItems) {
        if (selectedItems.isEmpty) {
          return const SizedBox();
        }
        return _chip(selectedItems);
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: labelTextSize),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          height: 0.9,
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding:
            const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 5),
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
        updateValueCallback(value: val);
      },
    );
  }

  Row _itemForm(String item, bool isSelect) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Text(
          item,
          style: TextStyle(
              fontSize: 16, color: isSelect ? primaryColor : Colors.black),
        ),
      ],
    );
  }

  Wrap _chip(List<String> selectedItems) {
    return Wrap(
      children: selectedItems.map((e) {
        return Container(
            margin: const EdgeInsets.only(right: 8, top: 5, bottom: 5),
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: IntrinsicWidth(
              child: Row(
                children: [
                  Text(
                    e,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Transform.scale(
                    scale: 1.8,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: IconButton(
                        splashRadius: 1,
                        onPressed: () {
                          selectedItems.remove(e);
                          updateValueCallback(value: selectedItems);
                        },
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ));
      }).toList(),
    );
  }
}
