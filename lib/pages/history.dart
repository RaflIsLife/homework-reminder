import 'package:flutter/material.dart';
import 'package:pengingat_pr/database/boxes.dart';
import 'package:pengingat_pr/database/history_database.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 40, 49),
      body: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Center(
          child: ListView.builder(
            itemCount: boxHistory.length,
            itemBuilder: (context, index) {
              HistoryDatabase history = boxHistory.getAt(index);
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
                      history.judul,
                      style: TextStyle(
                        
                          color: Color.fromARGB(255, 238, 238, 238)),
                    ),
                    subtitle: Text(
                      history.kategori.replaceAll(RegExp(r'key_'), ''),
                      style: TextStyle(
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
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 238, 238, 238),
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                       boxHistory.deleteAt(index);
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
                                'Pengingat: ${history.dateTimeList[0].toString().replaceRange(16, null, '')}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 238, 238, 238),
                                    fontSize: 8,
                                    ),
                              ),
                              Text(
                                'Deadline: ${history.dateTimeList[1].toString().replaceRange(16, null, '')}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 238, 238, 238),
                                    fontSize: 8,
                                   ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
