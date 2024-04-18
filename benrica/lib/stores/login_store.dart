import 'package:benrica/http/exceptions.dart';
import 'package:benrica/models/login_model.dart';
import 'package:benrica/repositories/login_repository.dart';
import 'package:flutter/material.dart';

class LoginStore {
  final ILoginRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final ValueNotifier<LoginModel> state = ValueNotifier<LoginModel>(LoginModel(
    access_token: '',
    expires_in: null,
    token_type: '',
    user: null,
    businesses: null,
    error: '',
    status: '',
    message: '',
    errors: null,
  ));

  final ValueNotifier<String> erro = ValueNotifier<String>("");

  LoginStore({required this.repository});

  Future doLogin(dynamic body, BuildContext context) async {
    isLoading.value = true;
    try {
      final result = await repository.doLogin(body, context);
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}
