import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pengingat_pr/database/boxes.dart';
import 'package:pengingat_pr/database/kategori_database.dart';
import 'package:pengingat_pr/database/pengingat_database.dart';

class Kategori extends StatefulWidget {
  const Kategori({super.key});
  @override
  State<Kategori> createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  final kategoriController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<KategoriDatabase> daftarKategori = boxKategori.keys.toList().cast();
    List<PengingatDatabase> daftarPengingat =
        boxPengingat.values.toList().cast();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 40, 49),
      body: Center(
        child: ListView.builder(
          itemCount: daftarKategori.length,
          itemBuilder: (context, index) {
            KategoriDatabase kategori = boxKategori.getAt(index);
            int jumlahPengingat = daftarPengingat
                .where((PengingatDatabase) =>
                    PengingatDatabase.kategori == kategori.key)
                .length;

            return Padding(
              padding: const EdgeInsets.only(left: 7, right: 7, top: 11),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 57, 62, 70),
                    border: Border.all(width: 0.01),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1.2,
                          spreadRadius: 2,
                          blurStyle: BlurStyle.solid,
                          offset: Offset(2.5, 3),
                          color: const Color.fromARGB(139, 0, 0, 0))
                    ],
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  minTileHeight: 72,
                  title: Text(
                    kategori.judulKategori,
                    style: TextStyle(color: Color.fromARGB(255, 238, 238, 238)),
                  ),
                  subtitle: Text("jumlah pengingat: $jumlahPengingat",
                      style: TextStyle(
                          color: Color.fromARGB(255, 238, 238,
                              238))), //berapa banyak pengingat yang ada di kategori
                  trailing: SizedBox(
                    width: 100,
                    child: Container(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                formUpdateKategori(context, index);
                              },
                              icon: Icon(Icons.edit),
                              color: Color.fromARGB(255, 238, 238, 238)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  boxKategori.deleteAt(index);
                                });
                              },
                              icon: Icon(Icons.delete),
                              color: Color.fromARGB(255, 238, 238, 238)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 7),
        child: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: const Color.fromARGB(255, 1, 141, 148),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Color.fromRGBO(190, 235, 219, 1),
                  title: Center(child: Text("Tambah Kategori")),
                  content: SizedBox(
                    height: 70,
                    child: Column(
                      children: [
                        //input Judul Kategori
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(180, 210, 200, 1),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: List.filled(
                              3,
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 2,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Colors.white,
                                ),
                                margin: EdgeInsets.only(top: 5),
                                height: 40,
                                child: TextField(
                                  controller: kategoriController,
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 5),
                                      hintText: "Judul Kategori",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(11))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actionsPadding: EdgeInsets.only(bottom: 20),
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color.fromRGBO(0, 123, 255, 1),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          boxKategori.put(
                              'key_${kategoriController.text}',
                              KategoriDatabase(
                                  judulKategori: kategoriController.text));
                        });
                        Navigator.pop(context);
                        kategoriController.clear();
                      },
                      child: Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromRGBO(150, 150, 150, 1))),
                      onPressed: () {
                        Navigator.pop(context);
                        kategoriController.clear();
                      },
                      child: Text(
                        "Batal",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.center,
                );
              },
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<dynamic> formUpdateKategori(BuildContext context, int index) {
    KategoriDatabase kategori = boxKategori.getAt(index);

    kategoriController.text = kategori.judulKategori;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(190, 235, 219, 1),
          title: Center(child: Text("Update Kategori")),
          content: SizedBox(
            height: 70,
            child: Column(
              children: [
                //input Judul Kategori
                Container(
                  padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(180, 210, 200, 1),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: List.filled(
                              3,
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 2,
                              ),
                            ),
                          ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Colors.white,
                                ),
                                margin: EdgeInsets.only(top: 5),
                                height: 40,
                        child: TextField(
                          controller: kategoriController,
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 5),
                            hintText: "Judul Kategori",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.only(bottom: 20),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color.fromRGBO(0, 123, 255, 1),
                        ),
                      ),
              onPressed: () {
                setState(
                  () {
                    boxKategori.putAt(
                        index,
                        KategoriDatabase(
                            judulKategori: kategoriController.text));
                  },
                );
                log(boxKategori.keyAt(index));
                Navigator.pop(context);
                kategoriController.clear();
              },
              child: Text("Update", style: TextStyle(color: Colors.white),),
            ),
            ElevatedButton(
              style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromRGBO(150, 150, 150, 1))),
              onPressed: () {
                Navigator.pop(context);
                kategoriController.clear();
              },
              child: Text("Batal", style: TextStyle(color: Colors.white),),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }
}
