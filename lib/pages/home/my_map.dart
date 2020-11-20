import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tugas_firebase_wisata/model/model_wisata.dart';
import 'my_detail_map.dart';

class MyMap extends StatefulWidget {
  final Position currentLocation;
  final String address;
  final List<ModelWisata> wisataList;
  MyMap({this.currentLocation, this.address, this.wisataList});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
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
    return widget.currentLocation == null
        ? Center(child: CircularProgressIndicator())
        : Card(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(widget.address ?? ''),
                Text(widget.currentLocation.toString() ?? ''),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          widget.currentLocation.latitude,
                          widget.currentLocation.longitude,
                        ),
                        zoom: 12.0,
                      ),
                      markers: _markers.values.toSet(),
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>[
                        Factory<OneSequenceGestureRecognizer>(
                            () => ScaleGestureRecognizer()),
                      ].toSet(),
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text('Tampilkan Full Screen'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeDetailMap(
                          wisataList: widget.wisataList,
                          currentLocation: widget.currentLocation,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
  }
}
