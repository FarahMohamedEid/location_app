import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../helpers/cache_helper.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin() {
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInAnonymously()
    .then((value){
      emit(LoginSuccessState(
        value.user!.uid
      ));
      CacheHelper.saveData(key: 'uID',value: value.user!.uid);
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });
  }


}
