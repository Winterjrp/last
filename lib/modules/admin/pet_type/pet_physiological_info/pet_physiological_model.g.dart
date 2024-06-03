// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_physiological_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetPhysiologicalModelAdapter extends TypeAdapter<PetPhysiologicalModel> {
  @override
  final int typeId = 8;

  @override
  PetPhysiologicalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PetPhysiologicalModel(
      petPhysiologicalId: fields[0] as String,
      petPhysiologicalName: fields[1] as String,
      description: fields[2] as String,
      nutrientLimitInfo: (fields[3] as List).cast<NutrientLimitInfoModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, PetPhysiologicalModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.petPhysiologicalId)
      ..writeByte(1)
      ..write(obj.petPhysiologicalName)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.nutrientLimitInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetPhysiologicalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
