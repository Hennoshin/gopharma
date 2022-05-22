import 'package:equatable/equatable.dart';
import 'package:gopharma/model/model_barang.dart';

class ModelCart extends Equatable {
  ModelBarang? barang;
  int? jumlah;
  int? totalHarga;

  ModelCart(
      { this.barang,  this.jumlah,  this.totalHarga});

  static isEmpty() => true;

  @override
  List<Object?> get props => [barang, jumlah, totalHarga];
}
