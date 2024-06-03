import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/modules/admin/admin_add_pet_info/models/post_for_recipe_model.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/popup/admin_cancel_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_error_popup.dart';
import 'package:last/modules/normal/get_recipe/get_recipe_view_model.dart';
import 'package:last/modules/normal/get_recipe/widgets/recipe_card.dart';
import 'package:last/modules/normal/get_recipe_from_algorithm/get_recipe_from_algorithm_view.dart';
import 'package:last/modules/normal/widgets/background.dart';
import 'package:last/utility/navigation_with_animation.dart';

class GetRecipeView extends StatefulWidget {
  final int selectedType;
  // final PostDataForRecipeModel postDataForRecipe;
  final GetRecipeModel getRecipeData;
  const GetRecipeView(
      {Key? key,
      required this.getRecipeData,
      // required this.postDataForRecipe,
      required this.selectedType})
      : super(key: key);

  @override
  State<GetRecipeView> createState() => _GetRecipeViewState();
}

class _GetRecipeViewState extends State<GetRecipeView> {
  late GetRecipeViewModel _viewModel;

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
    _viewModel = GetRecipeViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        AdminCancelPopup(cancelText: 'กลับไปเลือกวัตถุดิบ?', context: context)
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
              _operationButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Row _operationButton() {
    return Row(
      children: [
        const Spacer(),
        _backToHomeButton(),
        // widget.selectedType == 2
        //     ? const SizedBox()
        //     : Row(
        //         children: [
        //           const SizedBox(width: 10),
        //           _useAlgorithmButton(),
        //         ],
        //       ),
      ],
    );
  }

  SizedBox _backToHomeButton() {
    return SizedBox(
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
    );
  }

  // Future<void> _handleSearchRecipe() async {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return const Center(child: AdminLoadingScreen());
  //       });
  //   try {
  //     GetRecipeModel getRecipeData = await _viewModel.onUserSearchRecipe(
  //         postDataForRecipe: widget.postDataForRecipe);
  //     if (!context.mounted) return;
  //     Navigator.pop(context);
  //     Navigator.push(
  //       context,
  //       NavigationUpward(
  //         targetPage: GetRecipeFromAlgorithmView(getRecipeData: getRecipeData),
  //         durationInMilliSec: 500,
  //       ),
  //     );
  //   } catch (e) {
  //     Navigator.pop(context);
  //     Future.delayed(const Duration(milliseconds: 2200), () {
  //       Navigator.pop(context);
  //     });
  //     AdminErrorPopup(context: context, errorMessage: e.toString()).show();
  //   }
  // }

  // Widget _useAlgorithmButton() {
  //   return SizedBox(
  //     height: 45,
  //     width: 200,
  //     child: ElevatedButton(
  //       onPressed: () async {
  //         _handleSearchRecipe();
  //       },
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: red,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //       ),
  //       child: const Text(
  //         'ให้อัลกอริทึมสร้างสูตรอาหาร',
  //         style: TextStyle(fontSize: 17, color: Colors.white),
  //       ),
  //     ),
  //   );
  // }

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
                  isFromAlgorithm: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
