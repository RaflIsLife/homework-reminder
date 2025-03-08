
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pengingat_pr/database/boxes.dart';
import 'package:pengingat_pr/database/history_database.dart';
import 'package:pengingat_pr/database/kategori_database.dart';
import 'package:pengingat_pr/database/pengingat_database.dart';
import 'package:pengingat_pr/firebase/sync_service.dart';
import 'package:pengingat_pr/noti_service.dart';
import 'package:pengingat_pr/pages/history.dart';
import 'package:pengingat_pr/pages/login.dart';
import 'package:pengingat_pr/pages/home.dart';
import 'package:pengingat_pr/pages/kategori.dart';
import 'package:pengingat_pr/pages/profile.dart';
import 'package:pengingat_pr/pages/register.dart';
import 'package:timezone/data/latest.dart' as tz;

//firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

//TODO : RAPIHKAN CODINGANNYA-->FLOATING BUTTON ADA DI MAIN

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  //hive
  await Hive.initFlutter();
  Hive.registerAdapter(PengingatDatabaseAdapter());
  Hive.registerAdapter(KategoriDatabaseAdapter());
  Hive.registerAdapter(HistoryDatabaseAdapter());
  boxPengingat = await Hive.openBox<PengingatDatabase>('pengingatBox');
  boxKategori = await Hive.openBox<KategoriDatabase>('kategoriBox');
  boxHistory = await Hive.openBox<HistoryDatabase>('historyBox');

//notif
  NotiService().initNotification();

  //firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //firebase crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

if (FirebaseAuth.instance.currentUser != null) {
  // Pengguna sudah login, aktifkan sinkronisasi real-time
  SyncService().startRealTimeSync();
}

  //firebase auth
  FirebaseAuth.instance.authStateChanges().listen(
    (User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    },
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

class _MyAppState extends State<MyApp> {
  int page = 1;

  final listPage = [
    Kategori(),
    Home(),
    History(),
  ];
  final listNamePage = [
    'Kategori',
    'Home',
    'History',
  ];

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/profile': (context) => Profile(),
      },
      home: Builder(
        // Context di sini sudah berada di bawah Navigator yang dibuat oleh MaterialApp
        builder: (context) => Scaffold(
          backgroundColor: Color.fromARGB(255, 34, 40, 49),
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(35, 25),
                bottomRight: Radius.elliptical(35, 25),
              ),
            ),
            backgroundColor: Color.fromARGB(255, 0, 173, 181),
            toolbarHeight: 50,
            title: Center(child: Text(listNamePage[page])),
            actions: [
              IconButton(
                icon: Icon(Icons.people),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            (FirebaseAuth.instance.currentUser != null)
                                ? Profile()
                                : Login()),
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: Transform.translate(
            offset: Offset(0, 12),
            child: BottomNavigationBar(
              backgroundColor: Color.fromARGB(255, 1, 141, 148),
              elevation: 0,
              currentIndex: page,
              onTap: (index) {
                setState(() {
                  page = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_books, color: Colors.black),
                  label: '',
                  activeIcon: Icon(Icons.library_books,
                      color: Color.fromARGB(255, 238, 238, 238)),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.black),
                  label: '',
                  activeIcon: Icon(Icons.home,
                      color: Color.fromARGB(255, 238, 238, 238)),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history, color: Colors.black),
                  label: '',
                  activeIcon: Icon(Icons.history,
                      color: Color.fromARGB(255, 238, 238, 238)),
                ),
              ],
            ),
          ),
          body: listPage[page],
        ),
      ),
    );
  }
}
