import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/main_page_index_constants.dart';
import 'package:last/constants/size.dart';
import 'package:last/modules/admin/admin_home/admin_home_view_model.dart';
import 'package:last/modules/admin/admin_home/widgets/admin_card.dart';
import 'package:last/modules/admin/ingredient/ingredient_management/ingredient_management_view.dart';
import 'package:last/modules/admin/pet_type/pet_type_info_management/pet_type_info_management_view.dart';
import 'package:last/modules/admin/recipe/recipes_management/recipes_management_view.dart';
import 'package:last/modules/admin/widgets/admin_appbar.dart';
import 'package:last/modules/admin/widgets/admin_drawer.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen_with_text.dart';
import 'package:last/modules/admin/widgets/popup/admin_confirm_popup.dart';
import 'package:last/modules/normal/login/responsive_login_view.dart';
import 'package:last/provider/authentication_provider.dart';
import 'package:last/utility/navigation_with_animation.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  late AdminHomeViewModel _viewModel;
  late double _height;

  @override
  void initState() {
    super.initState();
    _viewModel = AdminHomeViewModel();
    _viewModel.getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _height = size.height;
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        AdminConfirmPopup(
          context: context,
          confirmText: 'ยืนยันการออกจากระบบ?',
          callback: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              NavigationDownward(
                targetPage: ChangeNotifierProvider<AuthenticationProvider>(
                    create: (context) => AuthenticationProvider(),
                    child: const LoginView()),
              ),
            );
          },
        ).show();
        return completer.future;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const AdminDrawer(
            currentIndex: MainPageIndexConstants.adminHomePageIndex),
        appBar: const AdminAppBar(color: Colors.white),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 30),
        constraints: const BoxConstraints(maxWidth: adminScreenMaxWidth),
        child: FutureBuilder<dynamic>(
            future: _viewModel.adminHomeDataFetch,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const AdminLoadingScreenWithText();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return _content();
              }
              return const Text('No data available');
            }),
      ),
    );
  }

  Column _content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        _header(),
        const SizedBox(height: 15),
        Expanded(
          child: Row(
            children: [
              _adminCard(),
              const SizedBox(width: 100),
              _picture(),
            ],
          ),
        ),
      ],
    );
  }

  Expanded _picture() {
    return Expanded(
      child: Column(
        children: [
          const Spacer(),
          Transform.scale(
            scale: 1.07,
            child: Lottie.asset(
              "assets/my_dog.json",
            ),
          ),
          SizedBox(height: _height * 0.18 - 130),
        ],
      ),
    );
  }

  Widget _adminCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 130, top: 20),
      child: Row(
        children: [
          Column(
            children: [
              const SizedBox(height: 60),
              AdminHomeCard(
                headerText: "จำนวนผู้ใช้งาน",
                icon: Icons.face_retouching_natural_rounded,
                amount: _viewModel.adminHomeData.totalUserAmount,
                callback: () {},
              ),
              const SizedBox(
                height: 25,
              ),
              AdminHomeCard(
                headerText: "ชนิดของสัตว์เลี้ยง",
                icon: Icons.cruelty_free,
                amount: _viewModel.adminHomeData.totalPetTypeAmount,
                callback: () {
                  Navigator.pushReplacement(
                    context,
                    NavigationUpward(
                      targetPage: const PetTypeInfoManagementView(),
                      durationInMilliSec: 350,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(width: 25),
          Column(
            children: [
              AdminHomeCard(
                headerText: "จำนวนวัตถุดิบ",
                icon: Icons.egg_alt_outlined,
                amount: _viewModel.adminHomeData.totalIngredientAmount,
                callback: () {
                  Navigator.pushReplacement(
                    context,
                    NavigationUpward(
                      targetPage: const IngredientManagementView(),
                      durationInMilliSec: 350,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 25,
              ),
              AdminHomeCard(
                headerText: "จำนวนสูตรอาหาร",
                icon: Icons.feed_outlined,
                amount: _viewModel.adminHomeData.totalRecipeAmount,
                callback: () {
                  Navigator.pushReplacement(
                    context,
                    NavigationUpward(
                      targetPage: const RecipeManagementView(),
                      durationInMilliSec: 350,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "สวัสดี ",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              "คุณ${_viewModel.retrievedUserInfo!.username}",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: darkFlesh,
                height: 1.4,
              ),
            ),
            const Text(
              " ยินดีต้อนรับเข้าสู่แอปพลิเคชันของเรา.. ",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Row(
          children: [
            Text(
              "มาร่วมเป็นส่วนหนึ่งในการเสริมสร้าง",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "สุขภาพสัตว์เลี้ยง",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: darkFlesh,
                height: 1.4,
              ),
            ),
            Text(
              "กันเถอะ!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _tempHome() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 1300,
          child: Row(
            children: [
              SizedBox(width: 350),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(" สวัสดีคุณ",
                          style: TextStyle(
                              fontSize: 40,
                              height: 1.5,
                              fontWeight: FontWeight.bold)),
                      Text(" 'Temp'",
                          style: TextStyle(
                              fontSize: 40,
                              height: 1.5,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text(" ยินดีต้อนรับเข้าสู่หน้า..",
                      style: TextStyle(fontSize: 40, height: 1.4)),
                  Text(
                    "HOME!",
                    style: TextStyle(
                        fontSize: 270,
                        fontWeight: FontWeight.bold,
                        height: 1.02),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
