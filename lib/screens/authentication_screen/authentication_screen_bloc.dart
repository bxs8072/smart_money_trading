import 'dart:async';

enum FormType { login, register, forgetPassword }

class AuthenticationScreenBloc {
  StreamController<FormType> controller =
      StreamController<FormType>.broadcast();

  Stream<FormType> get stream => controller.stream.asBroadcastStream();

  get dispose => controller.close();

  void update(FormType formType) {
    controller.sink.add(formType);
  }
}
