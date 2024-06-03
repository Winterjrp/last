import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';

class PetTypeInfoViewModel {
  late List<PetChronicDiseaseModel> filteredPetChronicDiseaseList;
  late List<PetChronicDiseaseModel> petChronicDiseaseList;

  void onUserSearchIngredient({required String searchText}) async {
    searchText = searchText.toLowerCase();
    if (searchText == '') {
      filteredPetChronicDiseaseList = petChronicDiseaseList;
    } else {
      filteredPetChronicDiseaseList = petChronicDiseaseList
          .where((petChronicDiseaseData) =>
              petChronicDiseaseData.petChronicDiseaseId
                  .toLowerCase()
                  .contains(searchText) ||
              petChronicDiseaseData.petChronicDiseaseName
                  .toLowerCase()
                  .contains(searchText))
          .toList();
    }
  }
}
