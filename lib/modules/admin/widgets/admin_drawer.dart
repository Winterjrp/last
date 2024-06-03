import 'dart:math';
import 'package:flutter/material.dart';
import 'package:last/constants/main_page_index_constants.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/modules/admin/admin_add_pet_info/admin_add_pet_profile_view.dart';
import 'package:last/utility/navigation_with_animation.dart';
import 'package:last/modules/normal/login/user_info_model.dart';
import 'package:last/modules/admin/admin_home/admin_home_view.dart';
import 'package:last/modules/admin/ingredient/ingredient_management/ingredient_management_view.dart';
import 'package:last/modules/admin/pet_type/pet_type_info_management/pet_type_info_management_view.dart';
import 'package:last/modules/admin/recipe/recipes_management/recipes_management_view.dart';
import 'package:last/services/shared_preferences_services/user_info.dart';

class AdminDrawer extends StatelessWidget {
  final int currentIndex;
  const AdminDrawer({required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: const Color.fromRGBO(248, 249, 248, 1),
        child: FutureBuilder<UserInfoModel?>(
          future: SharedPreferencesService.getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final UserInfoModel? userInfo = snapshot.data;
              if (userInfo != null) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          // const DrawerHeader(
                          //   decoration: BoxDecoration(
                          //     color: Colors.blue,
                          //   ),
                          //   child: Text(
                          //     'Drawer Header',
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 24,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.menu_open,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          const SizedBox(height: 10),
                          buildDrawerItem(
                            icon: Icons.home_filled,
                            text: 'Home',
                            pageIndex:
                                MainPageIndexConstants.adminHomePageIndex,
                            currentIndex: currentIndex,
                            targetPage: const AdminHomeView(),
                            context: context,
                          ),
                          buildDrawerItem(
                            icon: Icons.pets_rounded,
                            text: 'ค้นหาสูตรอาหารสัตว์เลี้ยง',
                            pageIndex: MainPageIndexConstants.myPetPageIndex,
                            currentIndex: currentIndex,
                            targetPage: AdminAddPetProfileView(
                              petProfileInfo: PetProfileModel(
                                  petId: "-1",
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
                                  nutritionalRequirementBase: []),
                            ),
                            context: context,
                          ),
                          // buildDrawerItem(
                          //   icon: Icons.face_retouching_natural_rounded,
                          //   text: 'จัดการผู้ใช้งาน',
                          //   pageIndex:
                          //       MainPageIndexConstants.userManagementIndex,
                          //   currentIndex: currentIndex,
                          //   targetPage: const UserManagementView(),
                          //   context: context,
                          // ),
                          buildDrawerItem(
                            icon: Icons.egg_alt_outlined,
                            text: 'จัดการวัตุดิบ',
                            pageIndex: MainPageIndexConstants
                                .ingredientManagementIndex,
                            currentIndex: currentIndex,
                            targetPage: const IngredientManagementView(),
                            context: context,
                          ),
                          buildDrawerItem(
                            icon: Icons.feed_outlined,
                            text: 'จัดการสูตรอาหาร',
                            pageIndex:
                                MainPageIndexConstants.recipeManagementIndex,
                            currentIndex: currentIndex,
                            targetPage: const RecipeManagementView(),
                            context: context,
                          ),
                          buildDrawerItem(
                            icon: Icons.coronavirus_outlined,
                            text:
                                'จัดการชนิดสัตว์เลี้ยง & โรคประจำตัวสัตว์เลี้ยง',
                            pageIndex:
                                MainPageIndexConstants.petTypeManagementIndex,
                            currentIndex: currentIndex,
                            targetPage: const PetTypeInfoManagementView(),
                            context: context,
                          ),
                          // buildDrawerItem(
                          //   icon: Icons.settings,
                          //   text: 'จัดการบัญชี',
                          //   pageIndex: 6,
                          //   currentIndex: currentIndex,
                          //   targetPage: const UserManagementView(),
                          //   context: context,
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      color: const Color.fromRGBO(35, 34, 35, 1),
                    )
                  ],
                );
              } else {
                return const Text('No user information found.');
              }
            }
          },
        ));
  }
}

Widget buildDrawerItem({
  required IconData icon,
  required String text,
  required int pageIndex,
  required int currentIndex,
  required Widget targetPage,
  required BuildContext context,
}) {
  bool isCurrent = pageIndex == currentIndex;
  bool specialCase = pageIndex == 5;
  Color textColor = isCurrent ? Colors.white : Colors.black;
  return isCurrent
      ? Container(
          margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(16, 16, 29, 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: _listTileContent(
              specialCase, textColor, icon, text, targetPage, context),
        )
      : _listTileContent(
          specialCase, textColor, icon, text, targetPage, context);
}

ListTile _listTileContent(bool specialCase, Color textColor, IconData icon,
    String text, Widget targetPage, BuildContext context) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
    leading: SizedBox(
        width: 55,
        child: specialCase
            ? Stack(
                children: [
                  Positioned(
                    top: 5,
                    left: 6,
                    child: Icon(
                      Icons.cruelty_free,
                      size: 30,
                      color: textColor,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 11,
                    child: Icon(
                      Icons.coronavirus_outlined,
                      size: 18,
                      color: textColor,
                    ),
                  ),
                ],
              )
            : Icon(
                icon,
                color: textColor,
              )),
    title: Text(
      text,
      style: TextStyle(color: textColor, fontSize: 17),
    ),
    onTap: () {
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          NavigationUpward(targetPage: targetPage, durationInMilliSec: 300));
    },
  );
}
