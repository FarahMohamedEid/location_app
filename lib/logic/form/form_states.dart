
abstract class FormStates{}

class FormInitialState extends FormStates{}

class FormLoadingState extends FormStates{}
class FormSuccessState extends FormStates{}
class FormErrorState extends FormStates {
  final String error;
  FormErrorState(this.error);
}


