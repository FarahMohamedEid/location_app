import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracker/helpers/utiles.dart';
import 'package:location_tracker/presentation/screens/form_screen.dart';
import 'package:location_tracker/style/colors.dart';
import '../../logic/login/login/login_cubit.dart';
import '../../logic/login/login/login_states.dart';
import '../widgets/asset_svg.dart';
import '../widgets/default_button.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Delivery App !',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline4!
                      .copyWith(
                    color: ColorStyle.textTitle,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: AssetSvg(
                    imagePath: 'fast-delivery',
                    size: 200.0,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocConsumer<LoginCubit, LoginStates>(
                    listener: (context, state) {
                      if (state is LoginErrorState) {
                        showToast(
                          text: state.error,
                          state: ToastStates.ERROR,
                        );
                      } else if (state is LoginSuccessState) {
                        navigateAndFinish(context, FormScreen(),);
                      }
                    },
                    builder: (context,state) {
                      return DefaultButton(
                        text: 'Sign In and Start',
                        color: ColorStyle.mainColor,
                        loading: state is LoginLoadingState,
                        onPressed: () {
                          BlocProvider.of<LoginCubit>(context).userLogin();
                        },
                      );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
