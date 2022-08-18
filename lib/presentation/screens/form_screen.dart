import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracker/helpers/cache_helper.dart';
import 'package:location_tracker/logic/main/cubit.dart';
import '../../helpers/utiles.dart';
import '../../logic/form/form_cubit.dart';
import '../../logic/form/form_states.dart';
import '../../style/colors.dart';
import '../widgets/default_button.dart';
import '../widgets/default_form_field.dart';
import 'home_screen.dart';

class FormScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  late var nameController = TextEditingController();
  late var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please, \n fill the form',
                    style:
                    Theme.of(context).textTheme.headline4!.copyWith(
                      color: ColorStyle.textTitle,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DefaultFormField(
                    controller: nameController,
                    hintText:'Name',
                    inputType: TextInputType.name,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'please input your name';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  DefaultFormField(
                    controller: phoneController,
                    hintText: 'Phone',
                    inputType: TextInputType.phone,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'please input your phone';
                      }else if(value.length != 11){
                        return 'phone number is not correct';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocConsumer<FormCubit,FormStates>(
                      listener: (context, state) {
                        if (state is FormErrorState) {
                          showToast(
                            text: state.error,
                            state: ToastStates.ERROR,
                          );
                        } else if (state is FormSuccessState) {
                          showToast(
                            text: "form submitted Successfully",
                            state: ToastStates.SUCCESS,
                          );
                          MainCubit.get(context).getUserData(userID: CacheHelper.getData(key: 'uID'));
                          navigateAndFinish(context, const HomeScreen());
                        }
                      },
                      builder: (context,state) {
                        return DefaultButton(
                          loading: state is FormLoadingState ? true : false,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              FormCubit.get(context).createUserForm(
                                name: nameController.text,
                                phone: phoneController.text,
                                uID: CacheHelper.getData(key: 'uID') ?? '',
                              );
                            }
                          },
                          text: 'submit',
                          color: ColorStyle.mainColor,
                        );
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
