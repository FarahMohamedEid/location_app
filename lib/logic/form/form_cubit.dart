import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracker/helpers/cache_helper.dart';
import 'package:location_tracker/logic/form/form_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/user_model.dart';


class FormCubit extends Cubit<FormStates> {
  FormCubit() : super(FormInitialState());

  static FormCubit get(context) => BlocProvider.of(context);

  void createUserForm({
    required String name,
    required String phone,
    required String uID,
  }) {
    emit(FormLoadingState());
    UserModel model = UserModel(
        name: name,
        phone: phone,
        uId: uID,
       );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .set(model.toMap()).then((value) {
          CacheHelper.saveData(key: 'formDone', value: true);
          emit(FormSuccessState());
    }).catchError((error){
          emit(FormErrorState(error));
    });
  }


}
