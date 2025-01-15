import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unik/Page/Beranda.dart';
import 'package:unik/db/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Memanggil database untuk memastikan inisialisasi
  try {
    final db = await DatabaseHelper.db(); // Mengakses db() secara statis
    print("Database berhasil dibuka!");
  } catch (e) {
    print("Gagal membuka database: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      title: 'ULASAN & NILAI PELAYANAN PUBLIK',
      home: const MyHomePage(title: 'UNIK Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Beranda(),
    );
  }
}
