import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_tracker/logic/main/states.dart';
import 'package:location_tracker/style/colors.dart';

import '../../data/directions_model.dart';
import '../../data/shipment_model.dart';
import '../../data/user_model.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(AppInitialStates());

  static MainCubit get(context) => BlocProvider.of(context);


  UserModel? user;
  void getUserData({required String userID}) {
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((value){
          user = UserModel.fromJson(value.data()!);
      emit(GetUserDataSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(GetUserDataErrorState());
    });
  }

  // get current location
  StreamSubscription? _locationSubscription;
  final Location _locationTracker = Location();
  Circle? circle;
  GoogleMapController? controller;
  bool isStarted = false;


  void getCurrentLocation(context,{required double disLat,required double disLng,required ShipmentModel shipment,required bool isStart}) async {
    emit(GetCurrentLocationLoading());
    try {
      var location = await _locationTracker.getLocation();

      updateCircle(location);
      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }
      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (controller != null) {
          controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude!, newLocalData.longitude!),
              tilt: 0,
              zoom: 16.00)));
          updateCircle(newLocalData);
          getDirections(
            origin:LatLng(newLocalData.latitude!,newLocalData.longitude!),
            destination: LatLng(disLat,disLng),
          );
            updateShipment(
              driverPhone: user!.phone!,
              driverName: user!.name!,
              driverLat: newLocalData.latitude!.toString(),
              driverLng: newLocalData.longitude!.toString(),
              shipmentID: shipment.shipId.toString(),
              timeOfStart: isStart? DateTime.now().toString() : shipment.timeOfStart!,
              destination:shipment.destination!,
              disLat: shipment.lat!,
              disLng: shipment.lng!,
              timeOfEnd: isStart? '' :DateTime.now().toString(),
              isDelivered: isStart? false:true
            );
          dispose();
        }
      });
      emit(GetCurrentLocationSuccess());

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
      emit(GetCurrentLocationError());
    }
  }
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
  }
  void updateCircle(LocationData newLocalData) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
      circle = Circle(
          circleId: const CircleId("car"),
          radius: newLocalData.heading!,
          zIndex: 1,
          center: latlng,
          fillColor: ColorStyle.mainColor,
          visible: false,
      );
    emit(UpdateLocationSuccess());
  }


  // Get directions
  Directions? info;
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio _dio = Dio();
  Future<Directions> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    emit(GetDirectionsLoading());
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': 'AIzaSyCeI9pUsFJZCTG0b7ZUvc2Kc9ziucgEQ9Y',
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      emit(GetDirectionsSuccess());
      return info = Directions.fromMap(response.data);
    }
    emit(GetDirectionsError());
    return Future<Directions>.error(response.statusCode!);
  }


  // Get shipments
  List<ShipmentModel> shipments = [];
  void getShipmentDetails(){
  emit(GetShipmentLoading());
  FirebaseFirestore.instance
      .collection('shipments')
      .orderBy('timeOfEnd', descending: true)
      .get()
      .then((value){
        shipments = value.docs.map((e) => ShipmentModel.fromJson(e.data())).toList();
        emit(GetShipmentSuccess());
  }).catchError((error){
        print(error.toString());
        emit(GetShipmentError());
      });
}

  // update shipment status
  void updateShipment({
    required String shipmentID,
    required String driverName,
    required String driverPhone,
    required String timeOfStart,
    required String driverLat,
    required String driverLng,
    required String destination,
    required String disLat,
    required String disLng,
    required String timeOfEnd,
    required bool isDelivered,
  }) {
    ShipmentModel model = ShipmentModel(
      shipId: shipmentID,
      driverLat: driverLat,
      driverLng: driverLng,
      driverName: driverName,
      driverPhone: driverPhone,
      timeOfStart: timeOfStart,
      isDelivered: isDelivered,
      destination: destination,
      lat: disLat,
      lng: disLng,
      timeOfEnd: timeOfEnd,
    );
    emit(UpdateShipmentLoading());
    FirebaseFirestore.instance
        .collection('shipments')
        .doc(shipmentID)
        .set(model.toMap()).then((value) {
      getShipmentDetails();
      emit(UpdateShipmentSuccess());
    }).catchError((error){
      emit(UpdateShipmentError());
    });
  }

}

