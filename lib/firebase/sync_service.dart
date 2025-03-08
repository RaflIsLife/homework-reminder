import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../database/kategori_database.dart';
import '../database/pengingat_database.dart';
import '../database/history_database.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

dynamic convertOnlineToHive(String collectionName, Map<String, dynamic> data) {
  switch (collectionName) {
    case 'kategori':
      return KategoriDatabase(
        judulKategori: data['judulKategori'] as String,
      );
    case 'pengingat':
      List<DateTime> dateList = (data['dateTimeList'] as List)
          .map((e) => (e as Timestamp).toDate())
          .toList();
      return PengingatDatabase(
        judul: data['judul'] as String,
        kategori: data['kategori'] as String,
        dateTimeList: dateList,
      );
    case 'history':
      List<DateTime> dateList = (data['dateTimeList'] as List)
          .map((e) => (e as Timestamp).toDate())
          .toList();
      return HistoryDatabase(
        judul: data['judul'] as String,
        kategori: data['kategori'] as String,
        dateTimeList: dateList,
      );
    default:
      return data;
  }
}

  // Fungsi konversi objek Hive ke Map untuk Firestore
  Map<String, dynamic> kategoriToMap(KategoriDatabase kategori) {
    return {
      'judulKategori': kategori.judulKategori,
    };
  }

  Map<String, dynamic> pengingatToMap(PengingatDatabase pengingat) {
    return {
      'judul': pengingat.judul,
      'kategori': pengingat.kategori,
      'dateTimeList':
          pengingat.dateTimeList.map((dt) => Timestamp.fromDate(dt)).toList(),
    };
  }

  Map<String, dynamic> historyToMap(HistoryDatabase history) {
    return {
      'judul': history.judul,
      'kategori': history.kategori,
      'dateTimeList':
          history.dateTimeList.map((dt) => Timestamp.fromDate(dt)).toList(),
    };
  }

  /// Mulai sinkronisasi secara real-time dari Hive ke Firestore.
  /// Setiap perubahan (tambah, update, hapus) di Hive akan otomatis diteruskan ke Firestore.
  void startRealTimeSync() {
    // Sinkronisasi untuk kategoriBox
    var kategoriBox = Hive.box<KategoriDatabase>('kategoriBox');
    kategoriBox.watch().listen((event) async {
      final key = event.key.toString();
      final data = event.value as KategoriDatabase?;
      if (data != null) {
        await _firestore.collection('kategori').doc(key).set(
              kategoriToMap(data),
            );
      } else {
        await _firestore.collection('kategori').doc(key).delete();
      }
    });

    // Sinkronisasi untuk pengingatBox
    var pengingatBox = Hive.box<PengingatDatabase>('pengingatBox');
    pengingatBox.watch().listen((event) async {
      final key = event.key.toString();
      final data = event.value as PengingatDatabase?;
      if (data != null) {
        await _firestore.collection('pengingat').doc(key).set(
              pengingatToMap(data),
            );
      } else {
        await _firestore.collection('pengingat').doc(key).delete();
      }
    });

    // Sinkronisasi untuk historyBox
    var historyBox = Hive.box<HistoryDatabase>('historyBox');
    historyBox.watch().listen((event) async {
      final key = event.key.toString();
      final data = event.value as HistoryDatabase?;
      if (data != null) {
        await _firestore.collection('history').doc(key).set(
              historyToMap(data),
            );
      } else {
        await _firestore.collection('history').doc(key).delete();
      }
    });
  }

  /// Sinkronisasi saat login: membandingkan data offline (Hive) dan online (Firestore)
  /// Jika terdapat konflik pada dokumen yang sama, akan muncul dialog untuk memilih data offline atau online.
  Future<void> syncOnLogin(BuildContext context) async {
    await _syncCollection('kategori', context);
    await _syncCollection('pengingat', context);
    await _syncCollection('history', context);
  }

  Future<void> _syncCollection(String collectionName, BuildContext context) async {
  // Pilih box dan fungsi konversi sesuai koleksi
  Box box;
  Map<String, dynamic> Function(dynamic) toMap;
  if (collectionName == 'kategori') {
    box = Hive.box<KategoriDatabase>('kategoriBox');
    toMap = (data) => kategoriToMap(data as KategoriDatabase);
  } else if (collectionName == 'pengingat') {
    box = Hive.box<PengingatDatabase>('pengingatBox');
    toMap = (data) => pengingatToMap(data as PengingatDatabase);
  } else if (collectionName == 'history') {
    box = Hive.box<HistoryDatabase>('historyBox');
    toMap = (data) => historyToMap(data as HistoryDatabase);
  } else {
    return;
  }

  // Ambil data lokal dari Hive
  Map<String, dynamic> localData = {};
  for (var key in box.keys) {
    var value = box.get(key);
    if (value != null) {
      localData[key.toString()] = toMap(value);
    }
  }

  // Ambil data online dari Firestore
  QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
  Map<String, dynamic> onlineData = {};
  for (var doc in snapshot.docs) {
    onlineData[doc.id] = doc.data();
  }

  // Kumpulkan key yang memiliki konflik (ada di kedua sisi)
  List<String> conflictKeys = [];
  for (var key in localData.keys) {
    if (onlineData.containsKey(key)) {
      conflictKeys.add(key);
    }
  }

  // Jika terdapat konflik, tampilkan satu dialog untuk menyelesaikannya
  if (conflictKeys.isNotEmpty) {
    bool useLocalForAll = await _showBulkConflictDialog(
      context,
      collectionName,
      conflictKeys,
      localData,
      onlineData,
    );
    // Untuk setiap key yang konflik, perbarui kedua sisi sesuai pilihan user
    for (var key in conflictKeys) {
      if (useLocalForAll) {
        // Gunakan data offline (Hive) dan update Firestore
        await _firestore.collection(collectionName).doc(key).set(localData[key]);
        // Karena data offline sudah berupa Map (hasil dari toMap), kita bisa langsung update ke Hive jika diperlukan
        // Namun, umumnya data di Hive sudah benar, jadi tidak perlu update ulang.
      } else {
        // Gunakan data online (Firestore)
        // Konversi data online (Map) menjadi objek Hive yang sesuai
        var converted = convertOnlineToHive(collectionName, onlineData[key]);
        await box.put(key, converted);
        // Update Firestore dengan data online (tetap menggunakan Map)
        await _firestore.collection(collectionName).doc(key).set(onlineData[key]);
      }
      onlineData.remove(key); // Hapus agar tidak diproses ulang
    }
  }

  // Data hanya ada di offline, masukkan ke Firestore
  for (var key in localData.keys) {
    if (!onlineData.containsKey(key)) {
      await _firestore.collection(collectionName).doc(key).set(localData[key]);
    }
  }

  // Data yang hanya ada online, masukkan ke Hive (dengan konversi)
  for (var key in onlineData.keys) {
    var converted = convertOnlineToHive(collectionName, onlineData[key]);
    await box.put(key, converted);
  }
}


  /// Dialog untuk menyelesaikan konflik secara _bulk_.
  /// Mengembalikan true jika user memilih data offline (local) untuk semua konflik,
  /// false jika memilih data online.
  Future<bool> _showBulkConflictDialog(
    BuildContext context,
    String collectionName,
    List<String> conflictKeys,
    Map<String, dynamic> localData,
    Map<String, dynamic> onlineData,
  ) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Konflik Data pada $collectionName"),
              content: Text(
                  "Terdapat ${conflictKeys.length} dokumen konflik. Pilih data yang akan digunakan untuk semua konflik:"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Pilih offline untuk semua
                  },
                  child: const Text("Offline"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Pilih online untuk semua
                  },
                  child: const Text("Online"),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
