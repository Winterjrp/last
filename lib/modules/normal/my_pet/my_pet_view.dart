import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/main_page_index_constants.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/utility/navigation_with_animation.dart';
import 'package:last/modules/normal/my_pet/my_pet_view_model.dart';
import 'package:last/modules/normal/my_pet/widgets/user_pet_info_card.dart';
import 'package:last/modules/normal/update_pet_profile/update_pet_profile_view.dart';
import 'package:last/modules/normal/widgets/background.dart';
import 'package:last/widgets/user_profile_app_bar.dart';
import 'package:last/modules/normal/widgets/bottom_navigation_bar.dart';

class MyPetView extends StatefulWidget {
  const MyPetView({Key? key}) : super(key: key);

  @override
  State<MyPetView> createState() => _MyPetViewState();
}

class _MyPetViewState extends State<MyPetView> {
  late double height;
  late MyPetViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MyPetViewModel();
    _viewModel.getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const ProjectNavigationBar(
          index: MainPageIndexConstants.myPetPageIndex),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 70),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(177, 225, 219, 0.9), // Top color
                          Color.fromRGBO(
                              177, 225, 219, 0.0) // Bottom color with opacity
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(50), // Adjust the radius as needed
                        topRight:
                            Radius.circular(50), // Adjust the radius as needed
                      ),
                    ),
                    child: const BackGround(
                        topColor: Color.fromRGBO(177, 225, 219, 0),
                        bottomColor: Color.fromRGBO(199, 232, 229, 0.5)),
                  ),
                  _content(height, width),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<dynamic> _content(double height, double width) {
    return FutureBuilder<dynamic>(
        future: _viewModel.getHomeData(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _loadingScreen();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Column(
              children: [
                UserProfileAppBar(
                  userInfo: _viewModel.retrievedUserInfo,
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      _header(),
                      const SizedBox(height: 5),
                      _viewModel.homeData.petList.isEmpty
                          ? _noPetWarn(width)
                          : _userPetInfo(height: height, context: context),
                      const SizedBox(height: 15),
                      _addPetButton()
                    ],
                  ),
                ),
              ],
            );
          }
          return const Text('No data available');
        });
  }

  Column _noPetWarn(double width) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(228, 234, 240, 1),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          width: width * 0.8,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const Text(
                "ยังไม่ได้เพิ่มข้อมูลสัตว์เลี้ยง?",
                style: TextStyle(
                    fontSize: 17, color: Color.fromRGBO(28, 28, 44, 1)),
              ),
              const SizedBox(height: 20),
              Transform.translate(
                offset: const Offset(100, 0),
                child: Transform.scale(
                  scale: 1.7,
                  child: SizedBox(
                    height: 290,
                    child: SvgPicture.asset(
                      'assets/pet_owner.svg',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "เพิ่มสัตว์เลี้ยงได้เลย!!",
                style: TextStyle(
                    fontSize: 18, color: Color.fromRGBO(28, 28, 44, 1)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Container _header() {
    return Container(
      alignment: Alignment.topLeft,
      child: const Text(
        "สัตว์เลี้ยงของฉัน",
        style: TextStyle(
            fontSize: 25, color: primary, fontWeight: FontWeight.bold),
      ),
    );
  }

  SingleChildScrollView _userPetInfo(
      {required double height, required BuildContext context}) {
    return SingleChildScrollView(
        child: SizedBox(
      height: height * 0.58,
      child: ListView.builder(
        itemCount: _viewModel.homeData.petList.length,
        itemBuilder: (context, index) {
          return UserPetInfoCard(
            context: context,
            petProfileInfo: _viewModel.homeData.petList[index],
          );
        },
      ),
    ));
  }

  Widget _loadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3.5,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "กำลังโหลดข้อมูล กรุณารอสักครู่...",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _addPetButton() {
    return Container(
        width: 200,
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              NavigationForward(
                  targetPage: UpdatePetProfileView(
                isCreate: true,
                petProfileInfo: PetProfileModel(
                  petId: Random().nextInt(999).toString(),
                  petName: "-1",
                  petType: "-1",
                  factorType: "factorType",
                  petFactorNumber: -1,
                  petWeight: -1,
                  petNeuteringStatus: "-1",
                  petAgeType: "-1",
                  petPhysiologyStatus: [],
                  petChronicDisease: [],
                  petActivityType: "-1",
                  updateRecent: "",
                  nutritionalRequirementBase: [],
                ),
              )),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            backgroundColor: const Color.fromRGBO(254, 208, 163, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                size: 40,
                color: primary,
              ),
              Text(
                " เพิ่มสัตว์เลี้ยง",
                style: TextStyle(
                    fontSize: 17, color: primary, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ));
  }
}
