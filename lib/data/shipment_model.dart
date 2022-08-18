class ShipmentModel {
  String? lat;
  String? lng;
  String? shipId;
  String? destination;
  String? driverName;
  String? driverPhone;
  String? timeOfStart;
  String? timeOfEnd;
  String? driverLat;
  String? driverLng;
  bool? isDelivered;

  ShipmentModel({
    this.lat,
    this.lng,
    this.shipId,
    this.destination,
    this.isDelivered,
    this.driverName,
    this.driverPhone,
    this.timeOfStart,
    this.timeOfEnd,
    this.driverLat,
    this.driverLng,
  });

  ShipmentModel.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    shipId = json['shipId'];
    destination = json['destination'];
    isDelivered = json['isDelivered'];
    driverName = json['driverName'];
    driverPhone = json['driverPhone'];
    timeOfStart = json['timeOfStart'];
    timeOfEnd = json['timeOfEnd'];
    driverLat = json['driverLat'];
    driverLng = json['driverLng'];
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'shipId': shipId,
      'destination': destination,
      'isDelivered': isDelivered,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'timeOfStart': timeOfStart,
      'timeOfEnd': timeOfEnd,
      'driverLat': driverLat,
      'driverLng': driverLng,
    };
  }
}
