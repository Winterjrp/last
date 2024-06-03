// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetProfileModelAdapter extends TypeAdapter<PetProfileModel> {
  @override
  final int typeId = 0;

  @override
  PetProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PetProfileModel(
      petId: fields[0] as String,
      petName: fields[1] as String,
      petType: fields[2] as String,
      factorType: fields[3] as String,
      petFactorNumber: fields[4] as double,
      petWeight: fields[5] as double,
      petNeuteringStatus: fields[6] as String,
      petAgeType: fields[7] as String,
      petPhysiologyStatus: (fields[8] as List).cast<String>(),
      petChronicDisease: (fields[9] as List).cast<String>(),
      petActivityType: fields[10] as String,
      updateRecent: fields[11] as String,
      nutritionalRequirementBase: (fields[12] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PetProfileModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.petId)
      ..writeByte(1)
      ..write(obj.petName)
      ..writeByte(2)
      ..write(obj.petType)
      ..writeByte(3)
      ..write(obj.factorType)
      ..writeByte(4)
      ..write(obj.petFactorNumber)
      ..writeByte(5)
      ..write(obj.petWeight)
      ..writeByte(6)
      ..write(obj.petNeuteringStatus)
      ..writeByte(7)
      ..write(obj.petAgeType)
      ..writeByte(8)
      ..write(obj.petPhysiologyStatus)
      ..writeByte(9)
      ..write(obj.petChronicDisease)
      ..writeByte(10)
      ..write(obj.petActivityType)
      ..writeByte(11)
      ..write(obj.updateRecent)
      ..writeByte(12)
      ..write(obj.nutritionalRequirementBase);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
