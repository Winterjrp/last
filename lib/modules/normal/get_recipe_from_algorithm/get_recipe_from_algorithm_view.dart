import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';
import 'package:last/modules/admin/widgets/popup/admin_cancel_popup.dart';
import 'package:last/modules/normal/get_recipe/widgets/recipe_card.dart';
import 'package:last/modules/normal/widgets/background.dart';

class GetRecipeFromAlgorithmView extends StatefulWidget {
  final GetRecipeModel getRecipeData;
  const GetRecipeFromAlgorithmView({Key? key, required this.getRecipeData})
      : super(key: key);

  @override
  State<GetRecipeFromAlgorithmView> createState() =>
      _GetRecipeFromAlgorithmViewState();
}

class _GetRecipeFromAlgorithmViewState
    extends State<GetRecipeFromAlgorithmView> {
  // static const Map<int, TableColumnWidth> _nutrientLimitTableColumnWidth =
  //     <int, TableColumnWidth>{
  //   0: FlexColumnWidth(0.06),
  //   1: FlexColumnWidth(0.2),
  //   2: FlexColumnWidth(0.1),
  //   3: FlexColumnWidth(0.1),
  //   4: FlexColumnWidth(0.1),
  // };
  // static const double _tableHeaderPadding = 12;
  // static const TextStyle _tableHeaderTextStyle =
  //     TextStyle(fontSize: 17, color: Colors.white);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        AdminCancelPopup(
                cancelText: 'กลับไปหน้าเพิ่มข้อมูลสัตว์เลี้ยง/เลือกวัตถุดิบ?',
                context: context)
            .show();
        return completer.future;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        const BackGround(
            topColor: Color.fromRGBO(222, 150, 154, 0.6),
            bottomColor: Color.fromRGBO(241, 165, 165, 0.2)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _searchedRecipe(),
              const SizedBox(height: 10),
              _backToHomeButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Row _backToHomeButton() {
    return Row(
      children: [
        const Spacer(),
        SizedBox(
          height: 45,
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: acceptButtonBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'กลับไปยังหน้าหลัก',
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchedRecipe() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "สูตรอาหาร",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: widget.getRecipeData.searchPetRecipesList.length,
              itemBuilder: (context, index) {
                return RecipeCard(
                  searchPetRecipeData:
                      widget.getRecipeData.searchPetRecipesList[index],
                  isFromAlgorithm: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
