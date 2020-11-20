import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tugas_firebase_wisata/model/model_wisata.dart';
import 'package:tugas_firebase_wisata/pages/detail_wisata/detail_screen.dart';
import 'package:tugas_firebase_wisata/pages/form/form_screen.dart';
import 'package:tugas_firebase_wisata/pages/home/my_map.dart';
import 'package:tugas_firebase_wisata/services/firebase_service.dart';
import 'package:tugas_firebase_wisata/services/geolocator_service.dart';
import 'package:tugas_firebase_wisata/shared/my_drawer.dart';
import 'package:tugas_firebase_wisata/shared/my_floating_button.dart';
import 'package:tugas_firebase_wisata/utils/my_styles.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ModelWisata> wisataList = [];

  User currentUser;
  Position currentPosition;
  String currentAddress;

  FirebaseService firebaseService = FirebaseService();
  GeolocatorService geolocatorService = GeolocatorService();

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _ref;

  StreamSubscription<Event> _onDataAddedSubscription;
  StreamSubscription<Event> _onDataChangedSubscription;

  void getCurrentPosition() async {
    currentPosition = await geolocatorService.getCurrentLocation();
    currentAddress = await geolocatorService.getAddressFromLatLng();
    setState(() {});
  }

  void getUser() async {
    currentUser = await firebaseService.getCurrentuser();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _ref = _database.reference().child('wisata');
    _onDataAddedSubscription = _ref.onChildAdded.listen(_onNewData);
    _onDataChangedSubscription = _ref.onChildAdded.listen(_onChangedData);

    geolocatorService.initGeolocator();
    getCurrentPosition();
    getUser();
  }

  @override
  void dispose() {
    super.dispose();
    _onDataAddedSubscription.cancel();
    _onDataChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Aplikasi Firebase Wisata'),
      ),
      drawer: MyDrawer(currentUser: currentUser),
      floatingActionButton: MyFloatingButton(),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Lihat di Peta',
              style: mTitleStyle,
            ),
          ),
          MyMap(
            currentLocation: currentPosition,
            address: currentAddress,
            wisataList: wisataList,
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 20,
            ),
            child: Text(
              'Daftar Tempat Wisata',
              style: mTitleStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 100,
              child: _showWisataList(),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _showWisataList() {
    if (wisataList.length > 0) {
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: wisataList.length,
        itemBuilder: (context, index) {
          ModelWisata wisata = wisataList[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    wisata: wisata,
                  ),
                ),
              );
            },
            child: Container(
              width: 400,
              child: Card(
                elevation: 5.0,
                child: ListTile(
                  leading: Image.network(wisata.urlFoto),
                  title: Text(wisata.nama),
                  subtitle: Text("${wisata.deskripsi}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormScreen(wisata: wisata),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await deleteWisata(wisata.key, index, wisata.urlFoto);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          color: Colors.red,
          child: Text(
            'Belum ada data wisata',
            style: mTitleStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Future<void> deleteWisata(String key, int index, String urlFoto) async {
    await _ref.child(key).remove();
    await FirebaseStorage.instance
        .getReferenceFromUrl(urlFoto)
        .then((result) => result.delete());
    setState(() {
      wisataList.removeAt(index);
    });
  }

  // LISTENER
  void _onNewData(Event event) {
    setState(() {
      wisataList.add(ModelWisata.fromSnapshot(event.snapshot));
    });
  }

  void _onChangedData(Event event) {
    var oldEntry = wisataList.singleWhere((wisata) {
      return wisata.key == event.snapshot.key;
    });

    setState(() {
      wisataList[wisataList.indexOf(oldEntry)] =
          ModelWisata.fromSnapshot(event.snapshot);
    });
  }
}
