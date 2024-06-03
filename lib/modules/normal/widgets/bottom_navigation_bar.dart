import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/main_page_index_constants.dart';
import 'package:last/modules/admin/admin_home/admin_home_view.dart';
import 'package:last/modules/normal/my_pet/my_pet_view.dart';
import 'package:last/modules/normal/setting/setting_view.dart';

class ProjectNavigationBar extends StatelessWidget {
  const ProjectNavigationBar({
    required this.index,
    Key? key,
  }) : super(key: key);
  final int index;
  // final HomeModel homeData;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Stack(
        children: [
          Container(
            color: const Color.fromRGBO(199, 232, 229, 0.65),
          ),
          Container(
            decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), // Adjust the radius as needed
                topRight: Radius.circular(30), // Adjust the radius as needed
              ),
            ),
            child:
                // (userInfo.userRole.isPetFoodManagementAdmin ||
                //         userInfo.userRole.isUserManagementAdmin)
                //     ? Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           _buildNavItem(
                //               icon: Icons.pets,
                //               // label: 'Home',
                //               navigationIndex: 0,
                //               context: context),
                //           _buildNavItem(
                //               icon: Icons.settings_outlined,
                //               // label: 'Settings',
                //               navigationIndex: 1,
                //               context: context),
                //           _buildNavItem(
                //               icon: Icons.admin_panel_settings,
                //               // label: 'Admin',
                //               navigationIndex: 2,
                //               context: context),
                //         ],
                //       )
                //     :
                Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                    icon: Icons.pets,
                    // label: 'Home',
                    navigationIndex: MainPageIndexConstants.myPetPageIndex,
                    context: context),
                _buildNavItem(
                    icon: Icons.person,
                    // label: 'Settings',
                    navigationIndex: 6,
                    context: context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      {required IconData icon,
      // required String label,
      required int navigationIndex,
      required BuildContext context}) {
    bool isHighLight() {
      if (index == navigationIndex) {
        return true;
      }
      return false;
    }

    Color color = Colors.white;
    return Center(
      child: GestureDetector(
        onTap: () async {
          if (navigationIndex == MainPageIndexConstants.myPetPageIndex) {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyPetView(),
              ),
            );
          } else if (navigationIndex == 1) {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingView(),
              ),
            );
          } else if (navigationIndex == 2) {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminHomeView(),
              ),
            );
          }
        },
        child: isHighLight()
            ? Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isHighLight()
                        ? const Color.fromRGBO(203, 139, 151, 1)
                        : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 35,
                  ),
                ),
              )
            : Icon(
                icon,
                color: color,
                size: 35,
              ),
      ),
    );
  }
}
