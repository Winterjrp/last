import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/modules/admin/pet_type/pet_physiological_info/pet_physiological_model.dart';
import 'package:last/modules/admin/pet_type/pet_type_info/widgets/nutrient_limit_info_table_cell.dart';

class PetPhysiologicalInfoTableCell extends StatefulWidget {
  final PetPhysiologicalModel petPetPhysiologicalInfo;
  final int index;
  final Map<int, TableColumnWidth> tableColumnWidth;
  final String petTypeName;

  const PetPhysiologicalInfoTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.petPetPhysiologicalInfo,
    required this.petTypeName,
  }) : super(key: key);

  @override
  PetPhysiologicalInfoTableCellState createState() =>
      PetPhysiologicalInfoTableCellState();
}

class PetPhysiologicalInfoTableCellState
    extends State<PetPhysiologicalInfoTableCell> {
  late bool _isHovered;

  static const EdgeInsets _tableCellPaddingInset =
      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);
  static const double _tableHeaderPadding = 12;
  static const TextStyle _tableHeaderTextStyle =
      TextStyle(fontSize: 17, color: Colors.white);
  static const Map<int, TableColumnWidth>
      _petChronicDiseaseNutrientLimitInfoTableColumnWidth =
      <int, TableColumnWidth>{
    0: FlexColumnWidth(0.1),
    1: FlexColumnWidth(0.2),
    2: FlexColumnWidth(0.1),
    3: FlexColumnWidth(0.15),
    4: FlexColumnWidth(0.15),
  };

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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SizedBox(
                      width: 1000,
                      height: 700,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _header(),
                          const SizedBox(height: 10),
                          _nutrientLimitTable(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
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

  Widget _nutrientLimitTable() {
    return Expanded(
      child: Column(
        children: [
          _tableHeader(),
          _tableBody(),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Table(
      columnWidths: _petChronicDiseaseNutrientLimitInfoTableColumnWidth,
      children: const [
        TableRow(
          decoration: BoxDecoration(
            color: specialBlack,
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
                    'สารอาหาร',
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
                    'หน่วย',
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
                    'min (%DM)',
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
                    'max (%DM)',
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

  Widget _tableBody() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.petPetPhysiologicalInfo.nutrientLimitInfo.length,
        itemBuilder: (context, index) {
          return NutrientLimitInfoTableCell(
            index: index,
            tableColumnWidth:
                _petChronicDiseaseNutrientLimitInfoTableColumnWidth,
            nutrientLimitInfo:
                widget.petPetPhysiologicalInfo.nutrientLimitInfo[index],
          );
        },
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Text(
          "ข้อมูลลักษณะทางสรีระวิทยา:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.petPetPhysiologicalInfo.petPhysiologicalName,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: const Text(
            "ของ",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.petTypeName,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
            widget.petPetPhysiologicalInfo.petPhysiologicalId,
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
          widget.petPetPhysiologicalInfo.petPhysiologicalName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
