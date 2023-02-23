// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitModelAdapter extends TypeAdapter<VisitModel> {
  @override
  final int typeId = 1;

  @override
  VisitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitModel(
      date: fields[0] as String,
      time: fields[1] as String,
      customerPhoneNumber: fields[2] as String,
      prDetails: (fields[3] as List?)
          ?.map((dynamic e) => (e as Map).map((dynamic k, dynamic v) =>
              MapEntry(k as String, (v as List).cast<Uint8List>())))
          .toList(),
      startKmImage: fields[4] as Uint8List?,
      endKmImage: fields[5] as Uint8List?,
      totalKm: fields[6] as String?,
      productName: (fields[7] as List?)?.cast<String>(),
      productImage: fields[8] as Uint8List?,
      invoiceNumber: fields[10] as String?,
      quotationNumber: fields[9] as String?,
      dateOfInstallation: fields[12] as String?,
      note: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VisitModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.customerPhoneNumber)
      ..writeByte(3)
      ..write(obj.prDetails)
      ..writeByte(4)
      ..write(obj.startKmImage)
      ..writeByte(5)
      ..write(obj.endKmImage)
      ..writeByte(6)
      ..write(obj.totalKm)
      ..writeByte(7)
      ..write(obj.productName)
      ..writeByte(8)
      ..write(obj.productImage)
      ..writeByte(9)
      ..write(obj.quotationNumber)
      ..writeByte(10)
      ..write(obj.invoiceNumber)
      ..writeByte(11)
      ..write(obj.note)
      ..writeByte(12)
      ..write(obj.dateOfInstallation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
