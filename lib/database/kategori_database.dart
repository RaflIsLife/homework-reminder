import 'package:hive/hive.dart';

part 'kategori_database.g.dart';

@HiveType(typeId: 2)
class KategoriDatabase extends HiveObject{
  KategoriDatabase({
    required this.judulKategori,
  });

  @HiveField(0)
  String judulKategori;
}