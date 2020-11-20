import 'package:flutter/material.dart';
import 'package:tugas_firebase_wisata/model/model_wisata.dart';
import 'map_detail.dart';

class DetailScreen extends StatefulWidget {
  final ModelWisata wisata;
  DetailScreen({this.wisata});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    ModelWisata _wisata = widget.wisata;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detail ${_wisata.nama}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyDetailMap(
              wisata: _wisata,
            ),
            SizedBox(height: 20),
            Container(
              child: Card(
                elevation: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(
                      _wisata.urlFoto,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Nama : ${_wisata.nama}"),
                          Text("Alamat : ${_wisata.alamat}"),
                          Text("Deskripsi : ${_wisata.deskripsi}"),
                          Text("Latitude : ${_wisata.lat.toString()}"),
                          Text("Longitude : ${_wisata.long.toString()}"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
