// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_type_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetTypeModelAdapter extends TypeAdapter<PetTypeModel> {
  @override
  final int typeId = 3;

  @override
  PetTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PetTypeModel(
      petTypeId: fields[0] as String,
      petTypeName: fields[1] as String,
      nutritionalRequirementBase:
          (fields[2] as List).cast<PetPhysiologicalModel>(),
      petPhysiological: (fields[3] as List).cast<PetPhysiologicalModel>(),
      petChronicDisease: (fields[4] as List).cast<PetChronicDiseaseModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, PetTypeModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.petTypeId)
      ..writeByte(1)
      ..write(obj.petTypeName)
      ..writeByte(2)
      ..write(obj.nutritionalRequirementBase)
      ..writeByte(3)
      ..write(obj.petPhysiological)
      ..writeByte(4)
      ..write(obj.petChronicDisease);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PetChronicDiseaseModelAdapter
    extends TypeAdapter<PetChronicDiseaseModel> {
  @override
  final int typeId = 4;

  @override
  PetChronicDiseaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PetChronicDiseaseModel(
      petChronicDiseaseId: fields[0] as String,
      petChronicDiseaseName: fields[1] as String,
      nutrientLimitInfo: (fields[2] as List).cast<NutrientLimitInfoModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, PetChronicDiseaseModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.petChronicDiseaseId)
      ..writeByte(1)
      ..write(obj.petChronicDiseaseName)
      ..writeByte(2)
      ..write(obj.nutrientLimitInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetChronicDiseaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
