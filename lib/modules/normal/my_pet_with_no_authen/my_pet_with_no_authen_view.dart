import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:last/constants/color.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/modules/normal/add_pet_profile_with_no_authen/add_pet_profile_with_no_authen_view.dart';
import 'package:last/modules/normal/login/responsive_login_view.dart';
import 'package:last/provider/authentication_provider.dart';
import 'package:last/utility/navigation_with_animation.dart';
import 'package:last/modules/normal/widgets/background.dart';

class MyPetWithNoAuthenticationView extends StatelessWidget {
  const MyPetWithNoAuthenticationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // double height = size.height;
    double width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         Navigator.pushReplacement(
            //           context,
            //           NavigationForward(
            //             targetPage:
            //                 ChangeNotifierProvider<AuthenticationProvider>(
            //                     create: (context) => AuthenticationProvider(),
            //                     child: const LoginView()),
            //           ),
            //         );
            //       },
            //       child: const Text(
            //         "Sign In",
            //         style: TextStyle(
            //           decoration: TextDecoration.underline,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 20),
              height: 80,
              child: const Row(
                children: [
                  Text(
                    "ค้นหาสูตรอาหารสัตว์เลี้ยง",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.pets, size: 28)
                ],
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(222, 150, 154, 0.6),
                          Color.fromRGBO(222, 150, 154, 0)
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(60), // Adjust the radius as needed
                        topRight:
                            Radius.circular(60), // Adjust the radius as needed
                      ),
                    ),
                    child: const BackGround(
                        topColor: Color.fromRGBO(222, 150, 154, 0),
                        bottomColor: Color.fromRGBO(241, 165, 165, 0.3)),
                  ),
                  _content(width: width, context: context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content({required double width, required BuildContext context}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(height: 35),
          // _header(),
          const SizedBox(height: 100),
          _noPetWarn(width),
          const SizedBox(height: 80),
          _addPetButton(context: context),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Column _noPetWarn(double width) {
    return Column(
      children: [
        // const SizedBox(height: 10),
        Container(
          // decoration: const BoxDecoration(
          //   color: Color.fromRGBO(228, 234, 240, 1),
          //   borderRadius: BorderRadius.all(Radius.circular(30)),
          // ),
          width: width * 0.9,
          child: Column(
            children: [
              // const Text(
              //   "ค้นหาสูตรอาหารสำหรับสัตว์เลี้ยงของคุณ..",
              //   style: TextStyle(
              //       fontSize: 18, color: Color.fromRGBO(28, 28, 44, 1)),
              // ),
              // const SizedBox(height: 40),
              Transform.translate(
                offset: const Offset(110, 0),
                child: Transform.scale(
                  scale: 1.65,
                  child: SizedBox(
                    height: 290,
                    child: SvgPicture.asset(
                      'assets/pet_owner.svg',
                      // semanticsLabel:
                      //     'My SVG Image',
                      // width: 200,
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              // const Text(
              //   "เพิ่มสัตว์เลี้ยงได้เลย!!",
              //   style: TextStyle(
              //       fontSize: 18, color: Color.fromRGBO(28, 28, 44, 1)),
              // ),
            ],
          ),
        ),
        // const SizedBox(height: 15),
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

  Widget _addPetButton({required BuildContext context}) {
    return Container(
      width: 250,
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        onPressed: () async {
          Navigator.push(
            context,
            NavigationForward(
              targetPage: AddPetProfileWithNoAuthenticationView(
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
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          backgroundColor: const Color.fromRGBO(254, 208, 163, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 25,
              color: primary,
            ),
            Text(
              " ค้นหาสูตรอาหาร",
              style: TextStyle(
                  fontSize: 19, color: primary, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
