import 'package:hive/hive.dart';

part 'pengingat_database.g.dart';

@HiveType(typeId: 1)
class PengingatDatabase extends HiveObject{
  PengingatDatabase({
    required this.judul,
    required this.kategori,
    required this.dateTimeList,
  });

  @HiveField(0)
  String judul;

  @HiveField(1)
  String kategori;

  @HiveField(2)
  List<DateTime> dateTimeList;
}