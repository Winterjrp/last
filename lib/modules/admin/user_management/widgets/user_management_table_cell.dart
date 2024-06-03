import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/modules/admin/user_management/user_management_view_model.dart';
import 'package:last/modules/admin/user_management/widgets/confirm_delete_user.dart';

// typedef OnShopGroupRemoveCallback = void Function(String shopGroupID);
typedef OnShopGroupRemoveCallback = void Function({required String userID});

class UserManagementTableCell extends StatelessWidget {
  const UserManagementTableCell({
    Key? key,
    required this.index,
    required this.viewModel,
    required this.shopGroupRemoveCallBack,
    required this.context,
    required this.tableColumnWidth,
  }) : super(key: key);

  final OnShopGroupRemoveCallback shopGroupRemoveCallBack;
  final int index;
  final UserManagementViewModel viewModel;
  final BuildContext context;
  final Map<int, TableColumnWidth> tableColumnWidth;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: tableColumnWidth,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: lightGrey,
              ),
            ),
          ),
          children: [
            _number(),
            _userID(),
            _username(),
            _isUserManagementAdmin(),
            _isPetFoodManagerAdmin(),
            _operatorButton(),
          ],
        ),
      ],
    );
  }

  TableCell _number() {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Text(
            (index + 1).toString(),
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }

  TableCell _userID() {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Text(
            viewModel.filterUserInfoList[index].userId,
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }

  TableCell _username() {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            viewModel.filterUserInfoList[index].username,
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }

  TableCell _isUserManagementAdmin() {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Text(
            viewModel.filterUserInfoList[index].userRole.isUserManagementAdmin
                .toString(),
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }

  TableCell _isPetFoodManagerAdmin() {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Text(
            viewModel
                .filterUserInfoList[index].userRole.isPetFoodManagementAdmin
                .toString(),
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }

  TableCell _operatorButton() {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          children: [
            // _showShopListButton(),
            // const SizedBox(
            //   width: 15,
            // ),
            // _shopGroupEditButton(),
            // const SizedBox(
            //   width: 6,
            // ),
            _shopGroupDeleteButton(),
          ],
        ),
      ),
    );
  }

  // Widget _showShopListButton() => SizedBox(
  //       width: 110,
  //       child: HoverButton(
  //         text: "รายชื่อร้านค้า",
  //         icon: null,
  //         onPressedCallBack: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ShopListView(
  //                 groupID: viewModel.filteredShopGroupList[index].shopGroupID,
  //                 groupName:
  //                     viewModel.filteredShopGroupList[index].shopGroupName,
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     );

  // SizedBox _shopGroupEditButton() {
  //   return SizedBox(
  //     height: 35,
  //     child: ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         padding: const EdgeInsets.symmetric(horizontal: 30),
  //         elevation: 0,
  //         backgroundColor: kPrimaryDarkColor, // Background color
  //       ),
  //       onPressed: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => GroupPresetEdit(
  //               groupId: viewModel.filteredShopGroupList[index].shopGroupID,
  //               groupName: viewModel.filteredShopGroupList[index].shopGroupName,
  //               shopAmount: viewModel.filteredShopGroupList[index].shopAmount,
  //             ),
  //           ),
  //         );
  //       },
  //       child: const Padding(
  //         padding: EdgeInsets.only(top: 1.5),
  //         child: Text(
  //           "แก้ไข",
  //           style: TextStyle(
  //             color: kWhiteColor,
  //             fontSize: 17,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Transform _shopGroupDeleteButton() {
    return Transform.scale(
      scale: 2,
      child: IconButton(
        splashRadius: 12,
        hoverColor: Colors.transparent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ConfirmDeleteUser(
                viewModel: viewModel,
                index: index,
                shopGroupRemoveCallBack: shopGroupRemoveCallBack,
              );
            },
          );
          // shopGroupRemoveCallBack(index);
        },
        icon: const Icon(
          Icons.delete,
          // color: kRedTextColor,
          size: 16,
        ),
      ),
    );
  }
}
