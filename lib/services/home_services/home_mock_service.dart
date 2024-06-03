import 'package:hive/hive.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/modules/normal/my_pet/models/home_model.dart';
import 'package:last/services/home_services/home_service_interface.dart';

class HomeMockService implements HomeServiceInterface {
  @override
  Future<MyPetModel> getPetListData({required String userID}) async {
    await Future.delayed(const Duration(milliseconds: 1200), () {});
    final petProfileListBox =
        await Hive.openBox<PetProfileModel>('petProfileListBox');
    List<PetProfileModel> petListData = petProfileListBox.values.toList();
    MyPetModel homeData = MyPetModel(petList: petListData);
    return homeData;
  }
}
