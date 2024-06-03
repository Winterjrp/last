import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';
import 'package:last/modules/admin/pet_type/pet_physiological_info/pet_physiological_model.dart';

typedef OnUserAddPetPhysiologicalCallBackFunction = void Function({
  required List<NutrientLimitInfoModel> nutrientLimitInfo,
  required String petPhysiologicalId,
  required String petPhysiologicalName,
  required String description,
});

typedef OnUserDeletePetPhysiologicalCallBackFunction = void Function(
    {required PetPhysiologicalModel petPhysiologicalData});

typedef OnUserEditPetPhysiologicalCallBackFunction = void Function(
    {required PetPhysiologicalModel petPhysiologicalData});

//------------------------------------------------------------------------------

typedef OnUserDeleteNutritionalRequirementCallbackFunction = void Function(
    {required PetPhysiologicalModel nutritionalRequirementData});

typedef OnUserAddNutritionalRequirementCallbackFunction = void Function({
  required List<NutrientLimitInfoModel> nutrientLimitInfo,
  required String petPhysiologicalId,
  required String petPhysiologicalName,
  required String description,
});
