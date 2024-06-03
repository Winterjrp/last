import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/modules/admin/pet_type/nutritional_requirement/nutritional_requirement_view.dart';
import 'package:last/modules/admin/pet_type/utils/typedef.dart';
import 'package:last/modules/admin/pet_type/pet_physiological_info/pet_physiological_info_view.dart';
import 'package:last/modules/admin/pet_type/pet_physiological_info/pet_physiological_model.dart';
import 'package:last/utility/navigation_with_animation.dart';

class NutritionalRequirementTableCell extends StatefulWidget {
  final String petTypeName;
  final PetPhysiologicalModel petPhysiologicalInfo;
  final int index;
  final Map<int, TableColumnWidth> tableColumnWidth;
  // final String petTypeName;
  final OnUserDeleteNutritionalRequirementCallbackFunction
      onUserDeleteNutritionalRequirementCallbackFunction;
  final OnUserAddNutritionalRequirementCallbackFunction
      onUserAddNutritionalRequirementCallback;
  final OnUserEditPetPhysiologicalCallBackFunction
      onUserEditPetPhysiologicalCallBack;
  const NutritionalRequirementTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.petPhysiologicalInfo,
    // required this.petTypeName,
    required this.onUserDeleteNutritionalRequirementCallbackFunction,
    required this.onUserAddNutritionalRequirementCallback,
    required this.onUserEditPetPhysiologicalCallBack,
    required this.petTypeName,
  }) : super(key: key);

  @override
  State<NutritionalRequirementTableCell> createState() =>
      _NutritionalRequirementTableCellState();
}

class _NutritionalRequirementTableCellState
    extends State<NutritionalRequirementTableCell> {
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
                targetPage: NutritionalRequirementBaseView(
                  index: widget.index,
                  petPhysiologicalInfo: widget.petPhysiologicalInfo,
                  petTypeName: widget.petTypeName,
                  onUserDeleteNutritionalRequirementCallback:
                      widget.onUserDeleteNutritionalRequirementCallbackFunction,
                  onUserAddPetPhysiologicalCallBack:
                      widget.onUserAddNutritionalRequirementCallback,
                  onUserEditPetPhysiologicalCallBack:
                      widget.onUserEditPetPhysiologicalCallBack,
                ),
                durationInMilliSec: 600),
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
            widget.petPhysiologicalInfo.petPhysiologicalId,
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
          widget.petPhysiologicalInfo.petPhysiologicalName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
