import 'package:flutter/material.dart';
import 'package:last/modules/normal/login/user_info_model.dart';

class UserProfileAppBar extends StatelessWidget {
  final UserInfoModel? userInfo;
  const UserProfileAppBar({
    required this.userInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(50),
              //   ),
              //   width: 50,
              //   height: 50,
              // ),
              // const SizedBox(width: 20),
              _userInfo(),
              // const Spacer(),
              // _cart(),
            ],
          ),
        ],
      ),
    );
  }

  Column _userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(userInfo!.username, style: const TextStyle(fontSize: 18)),
        Text(userInfo!.userId),
      ],
    );
  }

  // Widget _cart() {
  //   // Box box = Hive.box("LotteryPurchase");
  //   return MouseRegion(
  //     cursor: SystemMouseCursors.click,
  //     child: GestureDetector(
  //       onTap: () async {
  //         await Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => CartView(homeData: homeData),
  //           ),
  //         );
  //       },
  //       child: Stack(
  //         alignment: const Alignment(1, -1.3),
  //         children: [
  //           Container(
  //             decoration: BoxDecoration(
  //               color: const Color.fromRGBO(217, 217, 217, 1),
  //               borderRadius: BorderRadius.circular(50),
  //             ),
  //             width: 50,
  //             height: 50,
  //             child: Transform.scale(
  //               scale: 1.1,
  //               child: const Icon(Icons.shopping_cart_outlined),
  //             ),
  //           ),
  //           box.length == 0
  //               ? const SizedBox()
  //               : Container(
  //                   decoration: BoxDecoration(
  //                     color: Colors.red,
  //                     borderRadius: BorderRadius.circular(50),
  //                   ),
  //                   width: 20,
  //                   height: 20,
  //                   child: Center(
  //                     child: Text(box.length.toString(),
  //                         style: const TextStyle(
  //                             color: Colors.white, fontSize: 12)),
  //                   ),
  //                 ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
