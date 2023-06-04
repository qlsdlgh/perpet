import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:perpet/data/map_data.dart';

import '../data/my_location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  NLatLng? _initialPosition;
  late Future<List<HospitalModel>> hospital;
  late Future<List<PharmacyModel>> pharmacy;
  late Set<NMarker> hospitalMarkers = {};
  late Set<NMarker> pharmacyMarkers = {};

  @override
  initState() {
    super.initState();
    getLocation();
    hospital = HospitalModel.getHospitalList();
    pharmacy = PharmacyModel.getPharmacyList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildMarkers(hospital, pharmacy);
  }

  void getLocation() async {
    MyLocation myLocation = MyLocation();
    await myLocation.getMyCurrentLocation();
    double latitude = myLocation.latitude;
    double longitude = myLocation.longitude;
    _initialPosition = NLatLng(latitude, longitude);
    setState(() {});
  }

  Future<void> _buildMarkers(Future<List<HospitalModel>> hospital,
      Future<List<PharmacyModel>> pharmacy) async {
    List<HospitalModel> hospitalData = await hospital;
    List<PharmacyModel> pharmacyData = await pharmacy;

    for (var hos in hospitalData) {
      hospitalMarkers.add(NMarker(
          id: hos.name,
          icon: const NOverlayImage.fromAssetImage(
              'assets/icons/hospital_icon.png'),
          position: NLatLng(hos.latitude, hos.longitude),
          caption: NOverlayCaption(text: hos.name)));
    }

    for (var phar in pharmacyData) {
      pharmacyMarkers.add(NMarker(
        id: phar.name,
        icon: const NOverlayImage.fromAssetImage(
            'assets/icons/pharmacy_icon.png'),
        position: NLatLng(phar.latitude, phar.longitude),
        caption: NOverlayCaption(text: phar.name),
      ));
    }

    setState(() {});
  }

  Future<void> _buildMarkersInfo(Future<List<HospitalModel>> hospital) async {
    List<HospitalModel> hospitalData = await hospital;

    for (var hos in hospitalData) {
      hospitalMarkers.add(NMarker(
          id: hos.name, position: NLatLng(hos.latitude, hos.longitude)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text("지도"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        toolbarHeight: 60,
        bottomOpacity: 20,
      ),
      body: (_initialPosition == null)
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xffffBABA)),
            )
          : NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                    target: _initialPosition!, zoom: 15, bearing: 0, tilt: 0),
              ),
              onMapReady: (controller) async {
                await controller.addOverlayAll(hospitalMarkers);
                await controller.addOverlayAll(pharmacyMarkers);
                final initialmarker = NMarker(
                  icon: const NOverlayImage.fromAssetImage(''),
                  id: '_initialmarker',
                  position: _initialPosition!,
                );
                controller.addOverlay(initialmarker);
                controller.addOverlay(NInfoWindow.onMap(
                    id: '내 위치', text: '내 위치', position: _initialPosition!));
              },
            ),
    );
  }
}
