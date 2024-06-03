import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/main_page_index_constants.dart';
import 'package:last/constants/nutrient_list_template.dart';
import 'package:last/constants/size.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/update_recipe_view.dart';
import 'package:last/modules/admin/admin_home/admin_home_view.dart';
import 'package:last/modules/admin/recipe/recipes_management/widgets/recipe_management_table_cell.dart';
import 'package:last/modules/admin/widgets/button/admin_add_object_button.dart';
import 'package:last/modules/admin/widgets/filter_search_bar.dart';
import 'package:last/modules/admin/widgets/admin_appbar.dart';
import 'package:last/modules/admin/widgets/admin_drawer.dart';
import 'package:last/modules/admin/recipe/recipes_management/recipes_management_view_model.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen_with_text.dart';
import 'package:last/utility/navigation_with_animation.dart';

class RecipeManagementView extends StatefulWidget {
  const RecipeManagementView({Key? key}) : super(key: key);

  @override
  State<RecipeManagementView> createState() => _RecipeManagementViewState();
}

class _RecipeManagementViewState extends State<RecipeManagementView> {
  late RecipesManagementViewModel _viewModel;
  late TextEditingController _searchTextEditingController;

  static const Map<int, TableColumnWidth> _tableColumnWidth =
      <int, TableColumnWidth>{
    0: FlexColumnWidth(0.08),
    1: FlexColumnWidth(0.25),
    2: FlexColumnWidth(0.3),
    3: FlexColumnWidth(0.22),
  };
  static const double _tableHeaderPadding = 12;
  static const TextStyle _tableHeaderTextStyle =
      TextStyle(fontSize: 17, color: Colors.white);

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _viewModel = RecipesManagementViewModel();
    _viewModel.fetchRecipesListData();
    _searchTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        Navigator.pushReplacement(
          context,
          NavigationDownward(targetPage: const AdminHomeView()),
        );
        return completer.future;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        drawer: const AdminDrawer(
            currentIndex: MainPageIndexConstants.recipeManagementIndex),
        appBar: const AdminAppBar(color: backgroundColor),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: adminScreenMaxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: FutureBuilder<List<RecipeModel>>(
            future: _viewModel.recipeListData,
            builder: (context, AsyncSnapshot<List<RecipeModel>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const AdminLoadingScreenWithText();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 15),
                    _recipesListTable(context),
                    const SizedBox(height: 20),
                  ],
                );
              }
              return const Text('No data available');
            }),
      ),
    );
  }

  Widget _recipesListTable(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _tableHeader(),
          _tableBody(context: context),
        ],
      ),
    );
  }

  Table _tableHeader() {
    return Table(
      columnWidths: _tableColumnWidth,
      children: const [
        TableRow(
          decoration: BoxDecoration(
            color: Color.fromRGBO(16, 16, 29, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'ลำดับที่',
                    style: _tableHeaderTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'รหัสสูตรอาหาร',
                    style: _tableHeaderTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'ชื่อสูตรอาหาร',
                    style: _tableHeaderTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'สำหรับ (ชนิดสัตว์เลี้ยง)',
                    style: _tableHeaderTextStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onUserDeleteRecipe({required String recipeId}) async {
    await _viewModel.onUserDeleteRecipe(recipeId: recipeId);
  }

  Widget _tableBody({required BuildContext context}) {
    return Expanded(
      child: _viewModel.filteredRecipeList.isEmpty
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: tableBackGroundGradient),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ไม่มีข้อมูลสูตรอาหาร",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 50)
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(gradient: tableBackGroundGradient),
              child: ListView.builder(
                itemCount: _viewModel.filteredRecipeList.length,
                itemBuilder: (context, index) {
                  return RecipeTableCell(
                    index: index,
                    tableColumnWidth: _tableColumnWidth,
                    recipeInfo: _viewModel.filteredRecipeList[index],
                    onUserDeleteRecipeCallback: _onUserDeleteRecipe,
                    onUserEditRecipeCallback: _onUserEditRecipe,
                  );
                },
              ),
            ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "จัดการข้อมูลสูตรอาหารสัตว์เลี้ยง",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: headerTextFontSize,
            // color: kPrimaryDarkColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _searchBar(),
            const Spacer(),
            _addRecipesButton(),
          ],
        ),
      ],
    );
  }

  void _onSearchTextChanged({required String searchText}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _viewModel.onUserSearchIngredient(searchText: searchText);
      setState(() {});
    });
  }

  Widget _searchBar() {
    return SizedBox(
      width: 600,
      child: FilterSearchBar(
        onSearch: _onSearchTextChanged,
        searchTextEditingController: _searchTextEditingController,
        labelText: "ค้นหาสูตรอาหาร",
      ),
    );
  }

  Future<void> _onUserEditRecipe({required RecipeModel recipeData}) async {
    await _viewModel.onUserEditRecipe(recipeInfo: recipeData);
  }

  Widget _addRecipesButton() {
    return SizedBox(
        height: 43,
        child: AdminAddObjectButton(
            addObjectCallback: () {
              Navigator.push(
                context,
                NavigationUpward(
                  targetPage: UpdateRecipesView(
                    isCreate: true,
                    recipeInfo: RecipeModel(
                      recipeId: Random().nextInt(999).toString(),
                      recipeName: '',
                      petTypeName: '',
                      ingredientInRecipeList: [],
                      freshNutrientList: List.from(
                        primaryFreshNutrientListTemplate.map(
                          (nutrient) => NutrientModel(
                              nutrientName: nutrient.nutrientName,
                              amount: nutrient.amount,
                              unit: nutrient.unit),
                        ),
                      ),
                    ),
                    onUserEditRecipeCallback: _onUserEditRecipe,
                    onUserDeleteRecipesCallback: _onUserDeleteRecipe,
                  ),
                  durationInMilliSec: 400,
                ),
              );
            },
            addObjectText: " เพิ่มข้อมูลสูตรอาหาร"));
  }
}
