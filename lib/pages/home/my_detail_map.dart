import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tugas_firebase_wisata/model/model_wisata.dart';

class HomeDetailMap extends StatefulWidget {
  final List<ModelWisata> wisataList;
  final Position currentLocation;

  HomeDetailMap({this.wisataList, this.currentLocation});

  @override
  _HomeDetailMapState createState() => _HomeDetailMapState();
}

class _HomeDetailMapState extends State<HomeDetailMap> {
  final Map<String, Marker> _markers = {};

  _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _markers.clear();

      for (var wisata in widget.wisataList) {
        final marker = Marker(
          markerId: MarkerId(wisata.key),
          position: LatLng(wisata.lat, wisata.long),
          infoWindow: InfoWindow(
            title: wisata.nama,
            snippet: wisata.alamat,
          ),
        );
        _markers[wisata.nama] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Full Screen Map'),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.currentLocation.latitude,
                widget.currentLocation.longitude,
              ),
              zoom: 8.0,
            ),
            markers: _markers.values.toSet(),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(
                  () => ScaleGestureRecognizer()),
            ].toSet(),
          ),
        ),
      ),
    );
  }
}
