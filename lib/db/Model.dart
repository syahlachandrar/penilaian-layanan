class Ulasan {
  final int? id;
  final DateTime tanggalWaktu;
  final int jumlahBintang;
  final List<String> penilaian;
  final String pesan;

  Ulasan({
    this.id,
    required this.tanggalWaktu,
    required this.jumlahBintang,
    required this.penilaian,
    required this.pesan,
  });

  // Mengonversi objek Ulasan ke dalam Map untuk disimpan di database
  Map<String, dynamic> toMap() {
    return {
      'tanggal_waktu': tanggalWaktu.toIso8601String(),
      'jumlah_bintang': jumlahBintang,
      'penilaian': penilaian.join(', '),  // Jika penilaian adalah List<String>
      'pesan': pesan,
    };
  }

  // Mengonversi Map yang diambil dari database kembali ke dalam objek Ulasan
  factory Ulasan.fromMap(Map<String, dynamic> map) {
    return Ulasan(
      id: map['id'],
      tanggalWaktu: DateTime.parse(map['tanggal_waktu']),
      jumlahBintang: map['jumlah_bintang'],
      penilaian: map['penilaian'].split(', '),  // Mengubah string kembali menjadi List
      pesan: map['pesan'],
    );
  }
}
