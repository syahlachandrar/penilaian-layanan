import 'dart:async';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'Model.dart';

class DatabaseHelper {
  // Fungsi untuk membuka database
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      join(await sql.getDatabasesPath(), 'unik.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
        CREATE TABLE ulasan (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tanggal_waktu TEXT NOT NULL,
          jumlah_bintang INTEGER NOT NULL,
          penilaian TEXT NOT NULL,
          pesan TEXT NOT NULL
        )
        ''');
        print("Tabel ulasan berhasil dibuat.");
      },
    );
  }

  // Fungsi untuk memasukkan ulasan
  static Future<int> insertUlasan(Ulasan ulasan) async {
    final db = await DatabaseHelper.db();
    final data = ulasan.toMap();
    return db.insert('ulasan', data);
  }

  // Fungsi untuk mengambil semua ulasan
  static Future<List<Ulasan>> getAllUlasan() async {
    final db = await DatabaseHelper.db();
    final result = await db.query('ulasan');
    return result.map((map) => Ulasan.fromMap(map)).toList();
  }

  // Fungsi untuk mendapatkan ID tertinggi
  static Future<int> getLastId() async {
    final db = await DatabaseHelper.db();
    final result = await db.rawQuery('SELECT MAX(id) as maxId FROM ulasan');
    return result.first['maxId'] != null ? result.first['maxId'] as int : 0;
  }

  // Fungsi untuk menghitung jumlah ulasan
  static Future<int> countUlasan() async {
    final db = await DatabaseHelper.db();
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM ulasan');
    return result.first['count'] as int;
  }

  // Fungsi untuk menghitung rata-rata jumlah bintang
  static Future<double> averageUlasan() async {
    final db = await DatabaseHelper.db();
    final result = await db
        .rawQuery('SELECT AVG(jumlah_bintang) as avgRating FROM ulasan');
    return result.first['avgRating'] != null
        ? result.first['avgRating'] as double
        : 0.0;
  }

  // Fungsi untuk mengambil ulasan terbaru
  static Future<List<Ulasan>> getRecentUlasan() async {
    final db = await DatabaseHelper.db();
    final result = await db.query(
      'ulasan',
      orderBy: 'tanggal_waktu DESC',
      limit: 8,
    );
    return result.map((map) => Ulasan.fromMap(map)).toList();
  }

  // Fungsi untuk mendapatkan rata-rata ulasan per tanggal
  static Future<List<Map<String, dynamic>>> getAverageRatingByDate() async {
  final db = await DatabaseHelper.db();
  final result = await db.rawQuery('''
    SELECT 
      DATE(tanggal_waktu) as date, 
      AVG(jumlah_bintang) as averageRating
    FROM ulasan
    GROUP BY DATE(tanggal_waktu)
    ORDER BY DATE(tanggal_waktu) ASC
  ''');
  return result;
}


  // Fungsi untuk mendapatkan rata-rata ulasan dalam rentang waktu tertentu
  static Future<List<Map<String, dynamic>>> getAverageRatingByRange(
      String range) async {
    final db = await DatabaseHelper.db();
    final result = await db.rawQuery('''
      SELECT 
        DATE(tanggal_waktu) as date, 
        AVG(jumlah_bintang) as averageRating
      FROM ulasan
      WHERE tanggal_waktu >= date('now', '-$range day')
      GROUP BY DATE(tanggal_waktu)
      ORDER BY DATE(tanggal_waktu) ASC
    ''');
    return result;
  }

  static Future<Map<String, dynamic>> getRatingDistribution() async {
    final db = await DatabaseHelper.db();
    final result = await db.rawQuery('''
    SELECT 
      COUNT(*) as totalReviews,
      SUM(CASE WHEN jumlah_bintang = 5 THEN 1 ELSE 0 END) as fiveStars,
      SUM(CASE WHEN jumlah_bintang = 4 THEN 1 ELSE 0 END) as fourStars,
      SUM(CASE WHEN jumlah_bintang = 3 THEN 1 ELSE 0 END) as threeStars,
      SUM(CASE WHEN jumlah_bintang = 2 THEN 1 ELSE 0 END) as twoStars,
      SUM(CASE WHEN jumlah_bintang = 1 THEN 1 ELSE 0 END) as oneStar
    FROM ulasan
  ''');
    return result.isNotEmpty
        ? result.first.map((key, value) => MapEntry(key, value as int))
        : {
            'totalReviews': 0,
            'fiveStars': 0,
            'fourStars': 0,
            'threeStars': 0,
            'twoStars': 0,
            'oneStar': 0
          };
  }

  static Future<int> countUlasanByDate(DateTime date) async {
    final db = await DatabaseHelper.db();
    String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    
    var result = await db.rawQuery("SELECT COUNT(*) as count FROM ulasan WHERE DATE(tanggal_waktu) = ?", [formattedDate]);
    
    return result.isNotEmpty ? (result.first['count'] as int? ?? 0) : 0;
  }

  static Future<double> averageUlasanByDate(DateTime date) async {
    final db = await DatabaseHelper.db();
    String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    
    var result = await db.rawQuery("SELECT AVG(jumlah_bintang) as avg FROM ulasan WHERE DATE(tanggal_waktu) = ?", [formattedDate]);
    
    return result.isNotEmpty ? (result.first['avg'] as double? ?? 0.0) : 0.0;
  }

  // ✅ Fungsi untuk mengambil jumlah penilaian berdasarkan kategori
  static Future<Map<String, int>> getPenilaianCounts() async {
    final db = await DatabaseHelper.db();
    final result = await db.rawQuery('SELECT penilaian FROM ulasan');
    
    Map<String, int> counts = {
      'Sikap Petugas': 0,
      'Kualitas Pelayanan': 0,
      'Kompetensi Petugas': 0,
      'Waktu Pelayanan': 0,
      'Sarana Prasarana': 0,
    };

    for (var row in result) {
      String? penilaian = row['penilaian'] as String?;
      if (penilaian != null && penilaian.isNotEmpty) {
        List<String> aspek = penilaian.split(',');
        for (var a in aspek) {
          String aspekTrim = a.trim();
          if (counts.containsKey(aspekTrim)) {
            counts[aspekTrim] = (counts[aspekTrim] ?? 0) + 1;
          }
        }
      }
    }

    return counts;
  }
}
