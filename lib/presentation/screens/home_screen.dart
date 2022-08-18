import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracker/helpers/cache_helper.dart';
import 'package:location_tracker/helpers/utiles.dart';
import 'package:location_tracker/logic/main/cubit.dart';
import 'package:location_tracker/logic/main/states.dart';
import 'package:location_tracker/presentation/screens/shipment_details_screen.dart';

import '../../data/shipment_model.dart';
import '../../style/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainCubit.get(context).getUserData(userID: CacheHelper.getData(key: 'uID'));
    return Scaffold(
      body: BlocBuilder<MainCubit, MainStates>(builder: (context, state) {
        var cubit = MainCubit.get(context);
        if (cubit.user != null) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'welcome, ${cubit.user!.name}',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: ColorStyle.mainColor,
                            fontSize: 20,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Please choose your shipment',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: ColorStyle.textTitle,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      itemBuilder: ((context, index) => shipmentCard(
                        context,
                            shipment: cubit.shipments[index],
                            onTap: () {
                              navigateTo(context,ShipmentDetailsScreen(shipment: cubit.shipments[index],));
                            },
                          )),
                      itemCount: cubit.shipments.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorStyle.mainColor,
            ),
          );
        }
      }),
    );
  }
}

Widget shipmentCard(
    context,
    {
  required ShipmentModel shipment,
  required Function onTap,
}) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    color: shipment.isDelivered! ? ColorStyle.secondaryColor : Colors.white,
    child: InkWell(
      onTap: (){
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shipment.shipId!,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color:shipment.isDelivered! ?ColorStyle.textTitle: ColorStyle.mainColor,
                  ),
            ),
            const SizedBox(
              width: 10,
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
      ),
    ),
  );
}
