import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tugas_firebase_wisata/model/model_wisata.dart';

class MyDetailMap extends StatelessWidget {
  final ModelWisata wisata;
  MyDetailMap({this.wisata});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            wisata.lat,
            wisata.long,
          ),
          zoom: 11.0,
        ),
        markers: <Marker>[
          Marker(
              markerId: MarkerId(wisata.nama.toString()),
              position: LatLng(
                wisata.lat,
                wisata.long,
              ),
              infoWindow: InfoWindow(
                title: wisata.nama.toString(),
              )),
        ].toSet(),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory<OneSequenceGestureRecognizer>(() => ScaleGestureRecognizer()),
        ].toSet(),
      ),
    );
  }
}
