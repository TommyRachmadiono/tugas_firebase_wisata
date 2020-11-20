import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_firebase_wisata/model/model_wisata.dart';
import 'package:tugas_firebase_wisata/pages/form/form_map.dart';
import 'package:tugas_firebase_wisata/services/geolocator_service.dart';

class FormScreen extends StatefulWidget {
  final ModelWisata wisata;
  FormScreen({this.wisata});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  GeolocatorService geolocatorService = GeolocatorService();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _ref;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();

  bool isLoading = false;
  File _image;
  String fileName;
  String urlFoto;

  Future<void> getImageGallery() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage.path);
      fileName = basename(_image.path);
    });
  }

  Future<void> uploadFirebase() async {
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putFile(_image);

    urlFoto = await (await uploadTask.onComplete).ref.getDownloadURL();

    print("Image URL : $urlFoto");
  }

  updateData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await updateWisata(widget.wisata);
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  saveData() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await uploadFirebase();
        await addWisata();
      } catch (e) {
        print(e.toString());
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _ref = _database.reference().child('wisata');

    if (widget.wisata != null) {
      _namaController = TextEditingController(text: widget.wisata.nama);
      _alamatController = TextEditingController(text: widget.wisata.alamat);
      _deskripsiController =
          TextEditingController(text: widget.wisata.deskripsi);
      geolocatorService.lat = widget.wisata.lat;
      geolocatorService.long = widget.wisata.long;
      urlFoto = widget.wisata.urlFoto;
    }
  }

  @override
  Widget build(BuildContext context) {
    ModelWisata _wisata = widget.wisata;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Form Wisata'),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                validator: (value) =>
                    value.trim().isEmpty ? 'Nama tidak boleh kosong' : null,
                decoration: InputDecoration(
                  labelText: 'Nama',
                ),
              ),
              TextFormField(
                validator: (value) =>
                    value.trim().isEmpty ? 'Alamat tidak boleh kosong' : null,
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                ),
              ),
              TextFormField(
                validator: (value) => value.trim().isEmpty
                    ? 'Deskripsi tidak boleh kosong'
                    : null,
                controller: _deskripsiController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                ),
              ),
              Container(
                width: double.infinity,
                child: RaisedButton.icon(
                  onPressed: () {
                    getImageGallery();
                  },
                  icon: Icon(Icons.image_search),
                  label: Text('Photo'),
                ),
              ),
              _image == null
                  ? Text('No image selected')
                  : Image.file(_image,
                      width: 150, height: 150, fit: BoxFit.contain),
              FormMap(
                geolocatorService: geolocatorService,
                wisata: _wisata,
              ),
              SizedBox(height: 10),
              isLoading
                  ? Text('Loading. . . .')
                  : RaisedButton(
                      onPressed: () async {
                        _wisata == null ? await saveData() : await updateData();
                        Navigator.pop(context);
                      },
                      child: widget.wisata == null
                          ? Text('Simpan')
                          : Text('Update'),
                    ),
            ],
          ),
        ),
      )),
    );
  }

  // FUNGSI CRUD
  Future<void> addWisata() async {
    if (urlFoto != null) {
      ModelWisata wisata = ModelWisata(
        nama: _namaController.text,
        alamat: _alamatController.text,
        deskripsi: _deskripsiController.text,
        lat: geolocatorService.lat,
        long: geolocatorService.long,
        urlFoto: urlFoto,
      );

      await _ref.push().set(wisata.toJson());
    }
  }

  Future<void> updateWisata(ModelWisata wisata) async {
    wisata.nama = _namaController.text;
    wisata.alamat = _alamatController.text;
    wisata.deskripsi = _deskripsiController.text;
    wisata.lat = geolocatorService.lat;
    wisata.long = geolocatorService.long;
    if (_image != null) {
      await uploadFirebase();
      await FirebaseStorage.instance
          .getReferenceFromUrl(wisata.urlFoto)
          .then((result) => result.delete());
    }
    wisata.urlFoto = urlFoto;

    await _ref.child(wisata.key).set(wisata.toJson());
  }
}
