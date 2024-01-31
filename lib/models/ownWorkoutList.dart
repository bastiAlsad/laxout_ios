// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class UebungList {
  @HiveField(0)
  String imagePath;

  @HiveField(1)
  String execution;

  @HiveField(2)
  String name;

  @HiveField(3)
  int dauer;

  @HiveField(4)
  String videoPath;

  @HiveField(5)
  bool looping;

  @HiveField(6)
  bool added;

  @HiveField(7)
  String instruction;

  @HiveField(8)
  int id;

  @HiveField(9)
  bool timer;

  @HiveField(10)
  String required;

  UebungList({
    required this.imagePath,
    required this.execution,
    required this.name,
    required this.dauer,
    required this.videoPath,
    required this.looping,
    required this.added,
    required this.instruction,
    required this.id,
    required this.timer,
    required this.required,
  });
}

class UebungListAdapter extends TypeAdapter<UebungList> {
  @override
  final int typeId = 1;

  @override
  UebungList read(BinaryReader reader) {
    return UebungList(
      imagePath: reader.read(),
      execution: reader.read(),
      name: reader.read(),
      dauer: reader.read(),
      videoPath: reader.read(),
      looping: reader.read(),
      added: reader.read(),
      instruction: reader.read(),
      id: reader.read(),
      timer: reader.read(),
      required: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, UebungList obj) {
    writer.write(obj.imagePath);
    writer.write(obj.execution);
    writer.write(obj.name);
    writer.write(obj.dauer);
    writer.write(obj.videoPath);
    writer.write(obj.looping);
    writer.write(obj.added);
    writer.write(obj.instruction);
    writer.write(obj.id);
    writer.write(obj.timer);
    writer.write(obj.required);
  }
}
