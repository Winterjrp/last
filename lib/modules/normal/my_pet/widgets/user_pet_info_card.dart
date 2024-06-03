import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/utility/navigation_with_animation.dart';
import 'package:last/modules/normal/pet_profile/pet_profile_view.dart';

// typedef DeletePetInfoCallBack = void Function({required String petID});

class UserPetInfoCard extends StatelessWidget {
  final BuildContext context;
  // final DeletePetInfoCallBack deletePetInfoCallBack;
  final PetProfileModel petProfileInfo;
  const UserPetInfoCard({
    required this.context,
    required this.petProfileInfo,
    // required this.deletePetInfoCallBack,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      height: 130,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromRGBO(255, 237, 216, 0.9)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
        ),
        onPressed: () {
          Navigator.push(
              context,
              NavigationForward(
                  targetPage: PetProfileView(
                petProfileInfo: petProfileInfo,
                isJustUpdate: false,
              )));
          //   MaterialPageRoute(
          //       builder: (context) => PetProfileView(
          //             userInfo: userInfo,
          //             petProfileInfo: petProfileInfo,
          //             isJustUpdate: false,
          //           )),
          // );
        },
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.pets_outlined,
                  size: 70,
                  color: primary,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "น้อง: ${petProfileInfo.petName}",
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  petProfileInfo.petWeight == -1
                      ? const SizedBox()
                      : Column(
                          children: [
                            Text("น้ำหนัก: ${petProfileInfo.petWeight} Kg",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          ],
                        ),
                  Text(
                      "เลข factor: ${petProfileInfo.petFactorNumber.toString()}",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black)),
                  const Text("แก้ไขล่าสุด: 2 วันที่แล้ว",
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
