import 'package:hive/hive.dart';

part 'history_database.g.dart';

@HiveType(typeId: 3)
class HistoryDatabase extends HiveObject{
  HistoryDatabase({
    required this.judul,
    required this.kategori,
    required this.dateTimeList,
  });

  @HiveField(0)
  String judul;

  @HiveField(1)
  String kategori;

  @HiveField(2)
  List<DateTime>  dateTimeList;
}