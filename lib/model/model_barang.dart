import 'dart:convert';

ModelBarang ModelBarangFromJson(String str) => ModelBarang.fromJson(json.decode(str));

String ModelBarangToJson(ModelBarang data) => json.encode(data.toJson());

class ModelBarang {
  ModelBarang({
    required this.id,
    required this.nama,
    required this.harga,
    required this.jumlah,
    required this.deskripsi,
    required this.image,
  });

  String id;
  String nama;
  int harga;
  int jumlah;
  String deskripsi;
  String image;

  factory ModelBarang.fromJson(Map<String, dynamic> json) => ModelBarang(
    id: json["id"] ?? '',
    nama: json["nama"] ?? '',
    harga: json["harga"] ?? 0,
    jumlah: json["jumlah"] ?? 0,
    deskripsi: json["deskripsi"] ?? '',
    image: json["image"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "harga": harga,
    "jumlah": jumlah,
    "deskripsi": deskripsi,
    "image": image,
  };
}
