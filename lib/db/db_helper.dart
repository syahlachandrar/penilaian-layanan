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

  // Fungsi untuk mengupdate ulasan
  static Future<int> updateUlasan(Ulasan ulasan) async {
    final db = await DatabaseHelper.db();
    final data = ulasan.toMap();
    return db.update('ulasan', data, where: 'id = ?', whereArgs: [ulasan.id]);
  }

  // Fungsi untuk menghapus ulasan
  static Future<int> deleteUlasan(int id) async {
    final db = await DatabaseHelper.db();
    return db.delete('ulasan', where: 'id = ?', whereArgs: [id]);
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
    final result = await db.rawQuery('SELECT AVG(jumlah_bintang) as avgRating FROM ulasan');
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
  static Future<List<Map<String, dynamic>>> getAverageRatingByRange(String range) async {
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
}


// import 'dart:async';
// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:path/path.dart';
// import 'Model.dart';
//
// class DatabaseHelper {
//   // Fungsi untuk membuka database
//   static Future<sql.Database> db() async {
//     return sql.openDatabase(
//       join(await sql.getDatabasesPath(), 'unik.db'),
//       version: 1,
//       onCreate: (database, version) async {
//         // Membuat tabel ulasan
//         await database.execute('''
//         CREATE TABLE ulasan (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           tanggal_waktu TEXT NOT NULL,
//           jumlah_bintang INTEGER NOT NULL,
//           penilaian TEXT NOT NULL,
//           pesan TEXT NOT NULL
//         )
//       ''');
//         print("Tabel ulasan berhasil dibuat.");
//       },
//     );
//   }
//
//   // Fungsi untuk memasukkan ulasan
//   static Future<int> insertUlasan(Ulasan ulasan) async {
//     final db = await DatabaseHelper.db();
//     final data = ulasan.toMap();
//     return db.insert('ulasan', data);
//   }
//
//   // Fungsi untuk mengambil semua ulasan, mengonversi dari Map ke List<Ulasan>
//   static Future<List<Ulasan>> getAllUlasan() async {
//     final db = await DatabaseHelper.db();
//     final result = await db.query('ulasan'); // Ambil data ulasan dari tabel
//     // Mengonversi setiap Map ke objek Ulasan dan mengembalikannya dalam List
//     return result.map((map) => Ulasan.fromMap(map)).toList();
//   }
//
//   // Fungsi untuk mengupdate ulasan
//   static Future<int> updateUlasan(Ulasan ulasan) async {
//     final db = await DatabaseHelper.db();
//     final data = ulasan.toMap();
//     return db.update('ulasan', data, where: 'id = ?', whereArgs: [ulasan.id]);
//   }
//
//   // Fungsi untuk menghapus ulasan
//   static Future<int> deleteUlasan(int id) async {
//     final db = await DatabaseHelper.db();
//     return db.delete('ulasan', where: 'id = ?', whereArgs: [id]);
//   }
//
//   // Fungsi untuk mendapatkan ID tertinggi dari tabel ulasan
//   static Future<int> getLastId() async {
//     final db = await DatabaseHelper.db();
//     final result = await db.rawQuery('SELECT MAX(id) as maxId FROM ulasan');
//     return result.first['maxId'] != null ? result.first['maxId'] as int : 0;
//   }
//
//   // Tambahkan fungsi ini di dalam class DatabaseHelper
//   static Future<int> countUlasan() async {
//     final db = await DatabaseHelper.db();
//     final result = await db.rawQuery('SELECT COUNT(*) as count FROM ulasan');
//     return result.first['count'] as int;
//   }
//
//   static Future<double> averageUlasan() async {
//     final db = await DatabaseHelper.db();
//     final result = await db
//         .rawQuery('SELECT AVG(jumlah_bintang) as avgRating FROM ulasan');
//     return result.first['avgRating'] != null
//         ? result.first['avgRating'] as double
//         : 0.0;
//   }
//
//   static Future<List<Ulasan>> getRecentUlasan() async {
//     final db = await DatabaseHelper.db();
//     final result = await db.query(
//       'ulasan',
//       orderBy: 'tanggal_waktu DESC', // Mengurutkan berdasarkan tanggal
//       limit: 8, // Membatasi hanya 20 ulasan terbaru
//     );
//     return result.map((map) => Ulasan.fromMap(map)).toList();
//   }
//
//   // Tambahkan fungsi ini di dalam class DatabaseHelper
// static Future<List<Map<String, dynamic>>> getAverageRatingByDate() async {
//   final db = await DatabaseHelper.db();
//   // Query untuk mendapatkan rata-rata jumlah_bintang per tanggal
//   final result = await db.rawQuery('''
//     SELECT
//       DATE(tanggal_waktu) as date,
//       AVG(jumlah_bintang) as averageRating
//     FROM ulasan
//     GROUP BY DATE(tanggal_waktu)
//     ORDER BY DATE(tanggal_waktu) ASC
//   ''');
//   return result;
// }
//
// static Future<List<Map<String, dynamic>>> getAverageRatingByRange(String range) async {
//     final db = await DatabaseHelper.db();
//
//     String query = '''
//       SELECT
//         DATE(tanggal_waktu) as date,
//         AVG(jumlah_bintang) as averageRating
//       FROM ulasan
//       WHERE tanggal_waktu >= date('now', '-$range day')
//       GROUP BY DATE(tanggal_waktu)
//       ORDER BY DATE(tanggal_waktu) ASC
//     ''';
//
//     final result = await db.rawQuery(query);
//     return result;
//   }
//
//
// }
