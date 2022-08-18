import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracker/presentation/screens/home_screen.dart';
import 'package:location_tracker/presentation/screens/login_screen.dart';
import 'bloc_observer.dart';
import 'helpers/cache_helper.dart';
import 'logic/login/login/login_cubit.dart';
import 'logic/main/cubit.dart';
import 'logic/main/states.dart';
import 'logic/form/form_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();

  String userID =  CacheHelper.getData(key: 'uID') ?? '';
  bool formDone =  CacheHelper.getData(key: 'formDone') ?? false;

  runApp(MyApp(
    finishLogin: userID.isEmpty && formDone != true ? false : true,
  ));

}

class MyApp extends StatelessWidget {
  final bool? finishLogin;

  MyApp({this.finishLogin});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => FormCubit()),
        BlocProvider(create: (context) => MainCubit()..getShipmentDetails(),
        ),
      ],
      child: BlocConsumer<MainCubit, MainStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: finishLogin! ? const HomeScreen() : LoginScreen(),
          );
        },
      ),
    );
  }
}
