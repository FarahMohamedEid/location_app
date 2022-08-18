import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracker/data/shipment_model.dart';
import 'package:location_tracker/presentation/widgets/default_button.dart';
import 'package:location_tracker/style/colors.dart';
import '../../logic/main/cubit.dart';
import '../../logic/main/states.dart';

class ShipmentDetailsScreen extends StatelessWidget {
  ShipmentDetailsScreen({Key? key,required this.shipment}) : super(key: key);
  ShipmentModel shipment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainCubit, MainStates>(builder: (context, state) {
        var cubit = MainCubit.get(context);
        CameraPosition initialLocation = CameraPosition(
          target:
              LatLng(double.parse(shipment.lat!), double.parse(shipment.lng!)),
          zoom: 14.4746,
        );
        return SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                width: double.infinity,
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: initialLocation,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  myLocationEnabled: true,
                  markers: {
                    Marker(
                        markerId: const MarkerId("target"),
                        position: initialLocation.target,
                        rotation: initialLocation.bearing,
                        draggable: false,
                        zIndex: 2,
                        flat: false,
                        anchor: const Offset(0.5, 0.5),
                        icon: BitmapDescriptor.defaultMarker)
                  },
                  circles: Set.of((cubit.circle != null)
                      ? [cubit.circle!]
                      : []),
                  onMapCreated: (GoogleMapController controller) {
                    cubit.controller = controller;
                  },
                  polylines: {
                    if (cubit.info != null)
                      Polyline(
                        polylineId:
                            const PolylineId('overview_polyline'),
                        color: ColorStyle.mainColor,
                        width: 5,
                        points: cubit.info!.polylinePoints
                            .map((e) =>
                                LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: DefaultButton(
                  color: ColorStyle.mainColor,
                    text: 'Details',
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        useRootNavigator: true,
                        enableDrag: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        isDismissible: false,
                        builder: (BuildContext context) {
                          return BlocBuilder<MainCubit, MainStates>(
                            builder: (context, state) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                  MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: ColorStyle.baseWhite,
                                    borderRadius: BorderRadiusDirectional.only(
                                      topEnd: Radius.circular(30.0),
                                      topStart: Radius.circular(30.0),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //x button
                                      Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Text(
                                            'Details',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                              color: ColorStyle.textTitle,
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                            AlignmentDirectional.topEnd,
                                            child: InkWell(
                                              borderRadius:
                                              BorderRadius.circular(
                                                40.0,
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: const CircleAvatar(
                                                radius: 12.5,
                                                backgroundColor:
                                                ColorStyle.mainColor,
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20.0),
                                      // separator
                                      Container(
                                        width: double.infinity,
                                        height: 1.0,
                                        color: ColorStyle.secondaryColor,
                                      ),
                                      const SizedBox(height: 20.0),
                                      //shipment id
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Shipment ID: ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(
                                                color: ColorStyle.mainColor,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.5,
                                              child: Text(
                                                shipment.shipId!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                  color: ColorStyle.textTitle,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      //destination
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Destination: ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(
                                                color: ColorStyle.mainColor,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.5,
                                              child: Text(
                                                shipment.destination!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                  color: ColorStyle.textTitle,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12.0),
                                      //distance
                                      if (cubit.info != null)
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Distance: ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                  color: ColorStyle.mainColor,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.5,
                                                child: Text(
                                                  cubit.info!.totalDistance,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                    color: ColorStyle.textTitle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (cubit.info != null)
                                        const SizedBox(height: 12.0),
                                      //duration
                                      if (cubit.info != null)
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Duration: ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                  color: ColorStyle.mainColor,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.5,
                                                child: Text(
                                                  cubit.info!.totalDuration,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                    color: ColorStyle.textTitle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (cubit.info != null)
                                        const SizedBox(height: 12.0),
                                      const SizedBox(height: 40.0),
                                      BlocBuilder<MainCubit,MainStates>(
                                        builder: (context,state) {
                                          return DefaultButton(
                                            onPressed: () {
                                              if(shipment.isDelivered! == false){
                                                cubit.getCurrentLocation(context,
                                                    disLat: double.parse(shipment.lat!),
                                                    disLng: double.parse(shipment.lng!),
                                                    shipment: shipment,
                                                    isStart:cubit.isStarted? false :true

                                                );
                                                cubit.controller!.animateCamera(
                                                  cubit.info != null
                                                      ? CameraUpdate.newLatLngBounds(
                                                      cubit.info!.bounds, 100.0)
                                                      : CameraUpdate.newCameraPosition(
                                                      initialLocation),
                                                );
                                                cubit.isStarted = true;
                                              }
                                            },
                                            color:shipment.isDelivered! ?ColorStyle.secondaryColor :cubit.isStarted ? ColorStyle.secondaryColor:ColorStyle.mainColor,
                                            text: shipment.isDelivered! ?'Done !': cubit.isStarted ? 'Done !':'Start Now !',
                                            loading: state is UpdateShipmentLoading ? true : false,
                                          );
                                        }
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

