import 'package:flutter/material.dart';
import 'package:last/modules/admin/user_management/user_management_view_model.dart';

// typedef OnShopGroupRemoveCallback = void Function(String shopGroupID);
typedef OnShopGroupRemoveCallback = void Function({required String userID});

class ConfirmDeleteUser extends StatelessWidget {
  final OnShopGroupRemoveCallback shopGroupRemoveCallBack;
  final UserManagementViewModel viewModel;
  final int index;
  const ConfirmDeleteUser({
    required this.viewModel,
    required this.index,
    required this.shopGroupRemoveCallBack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: const Color.fromRGBO(255, 85, 85, 1), width: 2),
        ),
        child: const Icon(
          Icons.delete,
          color: Color.fromRGBO(255, 85, 85, 1),
          size: 70,
        ),
      ),
      // content: _deleteShopGroupInfo(),
      actionsPadding: const EdgeInsets.only(bottom: 20, top: 10),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('กลับ',
                    style: TextStyle(fontSize: 17, color: Colors.black)),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('ยืนยัน',
                    style: TextStyle(fontSize: 17, color: Colors.black)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Column _deleteShopGroupInfo() {
  //   String shopGroupName = viewModel.filteredShopGroupList[index].shopGroupName;
  //   int maxLength = 40;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       const Text(
  //         'ยืนยันการลบกลุ่มร้านค้า',
  //         style: kHeaderPopupTextStyle,
  //       ),
  //       Container(
  //         margin: const EdgeInsets.only(top: 5),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 const Text(
  //                   'กลุ่มร้านค้า ',
  //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //                 ),
  //                 Text(
  //                   shopGroupName.length <= maxLength
  //                       ? shopGroupName
  //                       : "${shopGroupName.substring(0, maxLength)}...",
  //                   maxLines: 1,
  //                   style: const TextStyle(fontSize: 18),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             Row(
  //               children: [
  //                 const Text(
  //                   'จำนวนร้านค้าทั้งหมด ',
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 18,
  //                   ),
  //                 ),
  //                 Text(
  //                   '${viewModel.filteredShopGroupList[index].shopAmount.toString()} ร้าน',
  //                   style: const TextStyle(fontSize: 18),
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
