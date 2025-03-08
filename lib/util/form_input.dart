

import 'package:flutter/material.dart';

Future<dynamic> formInput(
    BuildContext context,
    final judulController,
    final pengerjaanController,
    final deadlineController,
    String? kategoriTerpilih,
    List daftarKategori,
    VoidCallback showDateTimePicker,
    VoidCallback addPengingat,
    void Function(String?) statePilihKategori) {
  return showDialog(
    context: context,
    builder: (context) {
      var alertDialog2 = AlertDialog(
        title: Center(child: Text("Tambah Tugas")),
        content: SizedBox(
          height: 430,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //input judul tugas
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Judul Tugas",
                        style: TextStyle(fontSize: 17),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        height: 40,
                        child: TextField(
                          controller: judulController,
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 5),
                              hintText: "Judul",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //input kategori
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Kategori Tugas",
                        style: TextStyle(fontSize: 17),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        height: 60,
                        child: Container(
                          color: Colors.white54,
                          child: DropdownMenu<String>(
                            width: 220,
                            textAlign: TextAlign.center,
                            enableSearch: false,
                            enableFilter: false,
                            requestFocusOnTap: false,
                            hintText: "Pilih Kategori",
                            onSelected: statePilihKategori,
                            dropdownMenuEntries: daftarKategori.map((kategori) {
                              return DropdownMenuEntry(
                                value: kategori.key.toString(),
                                label: kategori.judulKategori,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //input tanggal pengerjaan
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Kapan Tugas ini dikerjakan dan dikumpulkan?",
                        style: TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        height: 170,
                        child: Column(
                          children: [
                            ElevatedButton(
                                onPressed: () => showDateTimePicker(),
                                child: Text("pilih tanggal&waktu")),
                            TextField(
                              controller: pengerjaanController,
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                              readOnly: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 5),
                                  hintText: "tanggal Pengerjaan",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11))),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            TextField(
                              controller: deadlineController,
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                              readOnly: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 5),
                                  hintText: "tanggal pengumpulan",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        actionsPadding: EdgeInsets.only(bottom: 20),
        actions: [
          ElevatedButton(
            onPressed: () {
              addPengingat;
              Navigator.pop(context);
            },
            child: Text("Simpan"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              judulController.clear();
              pengerjaanController.clear();
              deadlineController.clear();
            },
            child: Text("Batal"),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      );
      var alertDialog = alertDialog2;
      return alertDialog;
    },
  );
}
