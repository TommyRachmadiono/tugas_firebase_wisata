import 'package:firebase_database/firebase_database.dart';

class ModelWisata {
  final String key;
  String nama;
  String alamat;
  String deskripsi;
  String urlFoto;
  double lat;
  double long;

  ModelWisata({
    this.key,
    this.nama,
    this.alamat,
    this.deskripsi,
    this.urlFoto,
    this.lat,
    this.long,
  });

  ModelWisata.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        nama = snapshot.value['nama'],
        alamat = snapshot.value['alamat'],
        deskripsi = snapshot.value['deskripsi'],
        urlFoto = snapshot.value['urlFoto'],
        lat = snapshot.value['lat'],
        long = snapshot.value['long'];

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'alamat': alamat,
        'deskripsi': deskripsi,
        'urlFoto': urlFoto,
        'lat': lat,
        'long': long,
      };
}
