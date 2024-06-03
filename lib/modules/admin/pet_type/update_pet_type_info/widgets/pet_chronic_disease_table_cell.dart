import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/pet_type/pet_chronic_disease_info/pet_chronic_disease_info_view.dart';
import 'package:last/utility/navigation_with_animation.dart';

typedef OnUserDeletePetChronicDiseaseCallBackFunction = void Function(
    {required PetChronicDiseaseModel petChronicDiseaseData});
typedef OnUserAddPetChronicDiseaseCallBackFunction = void Function(
    {required List<NutrientLimitInfoModel> nutrientLimitInfo,
    required String petChronicDiseaseID,
    required String petChronicDiseaseName});
typedef OnUserEditPetChronicDiseaseCallBackFunction = void Function(
    {required String petChronicDiseaseId});

class PetChronicDiseaseTableCell extends StatefulWidget {
  final PetChronicDiseaseModel petChronicDisease;
  final int index;
  final Map<int, TableColumnWidth> tableColumnWidth;
  final String petTypeName;
  final OnUserDeletePetChronicDiseaseCallBackFunction
      onUserDeletePetChronicDiseaseCallBack;
  final OnUserAddPetChronicDiseaseCallBackFunction
      onUserAddPetChronicDiseaseCallBack;
  final OnUserEditPetChronicDiseaseCallBackFunction
      onUserEditPetChronicDiseaseCallBack;
  const PetChronicDiseaseTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.petChronicDisease,
    required this.petTypeName,
    required this.onUserDeletePetChronicDiseaseCallBack,
    required this.onUserAddPetChronicDiseaseCallBack,
    required this.onUserEditPetChronicDiseaseCallBack,
  }) : super(key: key);

  @override
  State<PetChronicDiseaseTableCell> createState() =>
      _PetChronicDiseaseTableCellState();
}

class _PetChronicDiseaseTableCellState
    extends State<PetChronicDiseaseTableCell> {
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
                targetPage: PetChronicDiseaseInfoView(
                  petTypeName: widget.petTypeName,
                  petChronicDiseaseInfo: widget.petChronicDisease,
                  onUserDeletePetChronicDiseaseCallBack: (
                      {required PetChronicDiseaseModel petChronicDiseaseData}) {
                    widget.onUserDeletePetChronicDiseaseCallBack(
                        petChronicDiseaseData: petChronicDiseaseData);
                  },
                  onUserAddPetChronicDiseaseCallBack: (
                      {required List<NutrientLimitInfoModel> nutrientLimitInfo,
                      required String petChronicDiseaseID,
                      required String petChronicDiseaseName}) {
                    widget.onUserAddPetChronicDiseaseCallBack(
                        nutrientLimitInfo: nutrientLimitInfo,
                        petChronicDiseaseID: petChronicDiseaseID,
                        petChronicDiseaseName: petChronicDiseaseName);
                  },
                  onUserEditPetChronicDiseaseCallBack: (
                      {required String petChronicDiseaseId}) {
                    widget.onUserEditPetChronicDiseaseCallBack(
                        petChronicDiseaseId: petChronicDiseaseId);
                  },
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
                  _petChronicDiseaseId(),
                  _petChronicDiseaseName(),
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

  TableCell _petChronicDiseaseId() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Center(
          child: Text(
            widget.petChronicDisease.petChronicDiseaseId,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  TableCell _petChronicDiseaseName() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Text(
          widget.petChronicDisease.petChronicDiseaseName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
