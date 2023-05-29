import 'dart:convert';

import 'package:flutter/services.dart';

class HospitalModel {
  final String name, addr;
  final double latitude, longitude;

  HospitalModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        addr = json['addr'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  static Future<List<HospitalModel>> getHospitalList() async {
    List<HospitalModel> hospitalInstances = [];
    final routeFromJson =
        await rootBundle.loadString('assets/json/daegu_animal_hospital.json');
    final List<dynamic> hospitals = jsonDecode(routeFromJson); //latest Dart

    for (var hospital in hospitals) {
      hospitalInstances.add(HospitalModel.fromJson(hospital));
    }
    return hospitalInstances;
  }
}

class PharmacyModel {
  final String name, addr;
  final double latitude, longitude;

  PharmacyModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        addr = json['addr'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  static Future<List<PharmacyModel>> getPharmacyList() async {
    List<PharmacyModel> pharmacyInstances = [];
    final routeFromJson =
        await rootBundle.loadString('assets/json/daegu_donggu_pharmacy.json');
    final List<dynamic> pharmacys = jsonDecode(routeFromJson); //latest Dart

    for (var pharmacy in pharmacys) {
      pharmacyInstances.add(PharmacyModel.fromJson(pharmacy));
    }
    return pharmacyInstances;
  }
}
