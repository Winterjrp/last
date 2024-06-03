import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/pet_type/pet_type_info/pet_type_info_view.dart';
import 'package:last/utility/navigation_with_animation.dart';

typedef OnUserDeletePetTypeCallBackFunction = Future<void> Function(
    {required String petTypeInfoId});

// typedef OnUserDeletePetChronicDiseaseCallBackFunction = void Function(
//     {required PetChronicDiseaseModel petChronicDiseaseData});

// typedef AddIngredientCallback = Future<void> Function(
//     {required IngredientModel ingredientData});
//
// typedef OnUserEditRecipeCallbackFunction = Future<void> Function(
//     {required RecipeModel recipeData});

class PetTypeInfoTableCell extends StatefulWidget {
  final int index;
  final Map<int, TableColumnWidth> tableColumnWidth;
  final PetTypeModel petTypeInfo;
  final OnUserDeletePetTypeCallBackFunction onUserDeletePetTypeCallback;
  // final OnUserDeletePetChronicDiseaseCallBackFunction
  //     onUserDeletePetChronicDiseaseCallBack;

  const PetTypeInfoTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.petTypeInfo,
    required this.onUserDeletePetTypeCallback,

    // required this.onUserDeletePetChronicDiseaseCallBack,
    // required this.onUserEditRecipeCallback,
  }) : super(key: key);

  @override
  State<PetTypeInfoTableCell> createState() => _PetTypeInfoTableCellState();
}

class _PetTypeInfoTableCellState extends State<PetTypeInfoTableCell> {
  static const EdgeInsets _tableCellPaddingInset =
      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);
  late bool _isHovered;

  @override
  void initState() {
    super.initState();
    _isHovered = false;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: _isHovered ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            NavigationUpward(
                targetPage: PetTypeInfoView(
                  petTypeInfo: widget.petTypeInfo,
                  onUserDeletePetTypeInfoCallBack: (
                      {required String petTypeId}) async {
                    await widget.onUserDeletePetTypeCallback(
                        petTypeInfoId: petTypeId);
                  },
                  isJustUpdate: false,
                ),
                durationInMilliSec: 350),
          );
        },
        child: Container(
          color: Colors.transparent,
          child: Table(
            columnWidths: widget.tableColumnWidth,
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: _isHovered
                      ? flesh
                      : widget.index % 2 == 1
                          ? Colors.white
                          : Colors.grey.shade100,
                ),
                children: [
                  _number(),
                  _petTypeId(),
                  _petTypeName(),
                  _petChronicDiseaseAmount(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableCell _number() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Center(
          child: Text(
            (widget.index + 1).toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  TableCell _petTypeId() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Center(
          child: Text(
            widget.petTypeInfo.petTypeId,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  TableCell _petChronicDiseaseAmount() {
    return TableCell(
      child: Center(
        child: Padding(
          padding: _tableCellPaddingInset,
          child: Text(
            widget.petTypeInfo.petChronicDisease.length.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  TableCell _petTypeName() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Text(
          widget.petTypeInfo.petTypeName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
