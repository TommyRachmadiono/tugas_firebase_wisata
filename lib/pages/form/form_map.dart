import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tugas_firebase_wisata/model/model_wisata.dart';
import 'package:tugas_firebase_wisata/services/geolocator_service.dart';

class FormMap extends StatefulWidget {
  final GeolocatorService geolocatorService;
  final ModelWisata wisata;

  FormMap({this.geolocatorService, this.wisata});

  @override
  _FormMapState createState() => _FormMapState();
}

class _FormMapState extends State<FormMap> {
  var latitude;
  var longitude;

  void getCurrentLocation() async {
    await widget.geolocatorService.getCurrentLocation();
    await widget.geolocatorService.getAddressFromLatLng();
    setState(() {
      latitude = widget.geolocatorService.lat;
      longitude = widget.geolocatorService.long;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.geolocatorService.initGeolocator();
    if (widget.wisata == null) {
      getCurrentLocation();
    } else {
      latitude = widget.wisata.lat;
      longitude = widget.wisata.long;
    }
  }

  @override
  Widget build(BuildContext context) {
    GeolocatorService geolocatorService = widget.geolocatorService;

    return latitude == null
        ? CircularProgressIndicator()
        : Card(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: GoogleMap(
                      onTap: (argument) {
                        print(argument);
                        setState(() {
                          geolocatorService.lat = argument.latitude;
                          geolocatorService.long = argument.longitude;
                          latitude = argument.latitude;
                          longitude = argument.longitude;
                        });
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          latitude,
                          longitude,
                        ),
                        zoom: 11.0,
                      ),
                      markers: <Marker>[
                        Marker(
                            markerId: MarkerId('Current Location'),
                            position: LatLng(
                              latitude,
                              longitude,
                            ),
                            infoWindow: InfoWindow(
                              title: 'Current Location',
                            )),
                      ].toSet(),
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>[
                        Factory<OneSequenceGestureRecognizer>(
                            () => ScaleGestureRecognizer()),
                      ].toSet(),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
