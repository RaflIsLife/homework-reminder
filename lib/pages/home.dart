import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:pengingat_pr/database/boxes.dart';
import 'package:pengingat_pr/database/history_database.dart';
import 'package:pengingat_pr/database/pengingat_database.dart';
import 'package:pengingat_pr/database/kategori_database.dart';
import 'package:pengingat_pr/noti_service.dart';

//TODO: notifikasi jika jam sekarang tepat pada pengingat

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final judulController = TextEditingController();
  final pengerjaanController = TextEditingController();
  final deadlineController = TextEditingController();
  String? kategoriTerpilih;
  late var tanggalAsli;

  List<KategoriDatabase> daftarKategori = boxKategori.values.toList().cast();

  void addPengingat() {
    setState(() {
      boxPengingat.add(PengingatDatabase(
          judul: judulController.text,
          kategori: kategoriTerpilih.toString(),
          dateTimeList: tanggalAsli));
      judulController.clear();
      pengerjaanController.clear();
      deadlineController.clear();
    });
  }

  Future<void> showDateTimePicker() async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime.now(),
      startLastDate: DateTime.now().add(const Duration(days: 3652)),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime.now(),
      endLastDate: DateTime.now().add(const Duration(days: 3652)),
      is24HourMode: true,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(begin: 0, end: 1),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );

    if (dateTimeList != null && dateTimeList.length == 2) {
      // Format DateTime ke string untuk ditampilkan di TextField
      String startDate =
          "${dateTimeList[0].day}-${dateTimeList[0].month}-${dateTimeList[0].year} ${dateTimeList[0].hour}:${dateTimeList[0].minute}";
      String endDate =
          "${dateTimeList[1].day}-${dateTimeList[1].month}-${dateTimeList[1].year} ${dateTimeList[1].hour}:${dateTimeList[1].minute}";

      // Masukkan ke dalam controller
      pengerjaanController.text = startDate;
      deadlineController.text = endDate;
      List<DateTime> dateTimeListNoSecond= dateTimeList.map((date) {
        return date.copyWith(second: 0);
      }).toList();
      tanggalAsli = dateTimeListNoSecond;
    }

    // pengerjaanController.text =
    //     dateTimeList![0].toString().replaceRange(16, null, '');
    // deadlineController.text =
    //     dateTimeList[1].toString().replaceRange(16, null, '');
    // tanggalAsli = dateTimeList;
  }

  final notiService = NotiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 40, 49),
      body: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Center(
          child: ListView.builder(
            itemCount: boxPengingat.length,
            itemBuilder: (context, index) {
              PengingatDatabase pengingat = boxPengingat.getAt(index);

              bool lewatDariDeadline =
                  (DateTime.now().isAfter(pengingat.dateTimeList[1]));
              // TROUBLESHOOT NOTIFIKASI:
              // final dateNoti = pengingat.dateTimeList[0]
              //     .toString()
              //     .replaceRange(10, null, '')
              //     .split('-')
              //     .cast();
              // final timeNoti = pengingat.dateTimeList[0]
              //     .toString()
              //     .replaceRange(0, 11, '')
              //     .replaceRange(5, null, '')
              //     .split(':')
              //     .cast();

              //     print(0);
              //     print(timeNoti[0]);

              if (DateTime.now().isBefore(pengingat.dateTimeList[0])) {
                notiService.showScheduleNotifications(
                    index: index,
                    title:
                        "Kerjakan tugas ${pengingat.kategori.replaceAll(RegExp(r'key_'), '')} mu",
                    body:
                        "ini waktunya untuk mengerjakan Tugas ${pengingat.judul}!!",
                    dateTimeNoti: pengingat.dateTimeList[0]);
              } else {
                notiService.cancelNotification(index: index);
              }

              // KategoriDatabase kategoriDatabase = boxKategori.getAt(index);
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
                    contentPadding: EdgeInsets.only(
                      right: 15,
                      left: 14,
                    ),
                    minTileHeight: 80,
                    title: Text(
                      pengingat.judul,
                      style: TextStyle(
                          decoration: lewatDariDeadline
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: Color.fromARGB(255, 238, 238, 238)),
                    ),
                    subtitle: Text(
                      pengingat.kategori.replaceAll(RegExp(r'key_'), ''),
                      style: TextStyle(
                          decoration: lewatDariDeadline
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: Color.fromARGB(255, 238, 238, 238)),
                    ),
                    trailing: SizedBox(
                      width: 140,
                      child: Stack(children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 39),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // IconButton(
                              //   color: lewatDariPengingat ?  const Color.fromARGB(188, 0, 0, 0) : Colors.transparent ,
                              //   visualDensity: VisualDensity.compact,
                              //   icon: Icon(Icons.check),
                              //   onPressed: () {
                              //     setState(() {
                              //     _lewatDariPengingatCek();
                              //     });
                              //   },
                              // ),
                              IconButton(
                                color: lewatDariDeadline
                                    ? Colors.transparent
                                    : const Color.fromARGB(255, 238, 238, 238),
                                visualDensity: VisualDensity.compact,
                                icon: Icon(Icons.edit),
                                onPressed: () =>
                                    formUpdatePengingat(context, index),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 238, 238, 238),
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      boxHistory.add(
                                        HistoryDatabase(
                                            judul: pengingat.judul,
                                            kategori: pengingat.kategori,
                                            dateTimeList:
                                                pengingat.dateTimeList),
                                      );
                                      boxPengingat.deleteAt(index);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Pengingat: ${pengingat.dateTimeList[0].toString().replaceRange(16, null, '')}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 238, 238, 238),
                                    fontSize: 8,
                                    decoration: lewatDariDeadline
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                              Text(
                                'Deadline: ${pengingat.dateTimeList[1].toString().replaceRange(16, null, '')}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 238, 238, 238),
                                    fontSize: 8,
                                    decoration: lewatDariDeadline
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                            ],
                          ),
                        )
                      ],),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Transform.translate(
        offset: Offset(0, 13),
        child: Transform.translate(
          offset: Offset(0, 10),
          child: Padding(
            padding: EdgeInsets.only(right: 15, bottom: 25),
            child: FloatingActionButton(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(500))),
              backgroundColor: const Color.fromARGB(255, 1, 141, 148),
              onPressed: () {
                formAddPengingat(context);
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> formAddPengingat(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        var alertDialog2 = AlertDialog(
          backgroundColor: Color.fromRGBO(190, 235, 219, 1),
          title: Center(child: Text("Tambah Tugas")),
          content: SizedBox(
            height: 430,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //input judul tugas
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
                        Text(
                          "Judul Tugas",
                          style: TextStyle(fontSize: 17),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.only(top: 5),
                          height: 40,
                          child: TextField(
                            controller: judulController,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 5),
                              hintText: "Judul",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
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
                        Text(
                          "Kategori Tugas",
                          style: TextStyle(fontSize: 17),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          height: 60,
                          child: Container(
                            color: const Color.fromARGB(255, 245, 250, 241),
                            child: DropdownMenu<String>(
                              width: 220,
                              textAlign: TextAlign.center,
                              enableSearch: false,
                              enableFilter: false,
                              requestFocusOnTap: false,
                              hintText: "Pilih Kategori",
                              onSelected: (String? newValue) {
                                setState(() {
                                  kategoriTerpilih = newValue!;
                                },);
                              },
                              dropdownMenuEntries:
                                  daftarKategori.map((kategori) {
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
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Color.fromRGBO(81, 216, 223, 1),
                                    ),
                                  ),
                                  onPressed: () => showDateTimePicker(),
                                  child: Text("pilih tanggal&waktu")),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Colors.white,
                                ),
                                margin: EdgeInsets.only(top: 5),
                                height: 40,
                                child: TextField(
                                  controller: pengerjaanController,
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 5),
                                      hintText: "tanggal Pengerjaan",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(11))),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Colors.white,
                                ),
                                margin: EdgeInsets.only(top: 5),
                                height: 40,
                                child: TextField(
                                  controller: deadlineController,
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 5),
                                      hintText: "tanggal pengumpulan",
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
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromRGBO(0, 123, 255, 1),
                ),
              ),
              onPressed: () {
                addPengingat();
                Navigator.pop(context);
              },
              child: Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromRGBO(150, 150, 150, 1))),
              onPressed: () {
                Navigator.pop(context);
                judulController.clear();
                pengerjaanController.clear();
                deadlineController.clear();
              },
              child: Text(
                "Batal",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
        var alertDialog = alertDialog2;
        return alertDialog;
      },
    );
  }

  Future<dynamic> formUpdatePengingat(BuildContext context, int index) {
    var pengingat = boxPengingat.getAt(index);
    judulController.text = pengingat.judul;
    kategoriTerpilih = pengingat.kategori;
    pengerjaanController.text = pengingat.dateTimeList[0].toString();
    deadlineController.text = pengingat.dateTimeList[1].toString();
    tanggalAsli = pengingat.dateTimeList;

    return showDialog(
      context: context,
      builder: (context) {
        var alertDialog2 = AlertDialog(
          backgroundColor: Color.fromRGBO(190, 235, 219, 1),
          title: Center(child: Text("Update Tugas")),
          content: SizedBox(
            height: 430,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //input judul tugas
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
                        Text(
                          "Judul Tugas",
                          style: TextStyle(fontSize: 17),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.only(top: 5),
                          height: 40,
                          child: TextField(
                            controller: judulController,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 5),
                              hintText: "Judul",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
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
                        Text(
                          "Kategori Tugas",
                          style: TextStyle(fontSize: 17),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          height: 60,
                          child: Container(
                            color: const Color.fromARGB(255, 245, 250, 241),
                            child: DropdownMenu<String>(
                              width: 220,
                              textAlign: TextAlign.center,
                              enableSearch: false,
                              enableFilter: false,
                              requestFocusOnTap: false,
                              hintText: "Pilih Kategori",
                              onSelected: (String? newValue) {
                                setState(() {
                                  kategoriTerpilih = newValue!;
                                });
                              },
                              dropdownMenuEntries:
                                  daftarKategori.map((kategori) {
                                return DropdownMenuEntry(
                                  value: kategori.judulKategori,
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
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Color.fromRGBO(81, 216, 223, 1),
                                    ),
                                  ),
                                  onPressed: () => showDateTimePicker(),
                                  child: Text("pilih tanggal&waktu")),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Colors.white,
                                ),
                                margin: EdgeInsets.only(top: 5),
                                height: 40,
                                child: TextField(
                                  controller: pengerjaanController,
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 5),
                                      hintText: "tanggal Pengerjaan",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(11))),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Colors.white,
                                ),
                                margin: EdgeInsets.only(top: 5),
                                height: 40,
                                child: TextField(
                                  controller: deadlineController,
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 5),
                                      hintText: "tanggal pengumpulan",
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
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromRGBO(0, 123, 255, 1),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  boxPengingat.putAt(
                      index,
                      PengingatDatabase(
                          judul: judulController.text,
                          kategori: kategoriTerpilih.toString(),
                          dateTimeList: tanggalAsli));
                  judulController.clear();
                  pengerjaanController.clear();
                  deadlineController.clear();
                });
              },
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromRGBO(150, 150, 150, 1))),
              onPressed: () {
                Navigator.pop(context);
                judulController.clear();
                pengerjaanController.clear();
                deadlineController.clear();
              },
              child: Text(
                "Batal",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
        var alertDialog = alertDialog2;
        return alertDialog;
      },
    );
  }
}
