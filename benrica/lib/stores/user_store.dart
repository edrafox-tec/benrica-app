import 'package:benrica/http/exceptions.dart';
import 'package:benrica/models/user_create_model.dart';
import 'package:benrica/repositories/user_create_repository.dart';
import 'package:flutter/material.dart';

class UserCreateStore {
  final IUserCreateRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final ValueNotifier<UserCreateResponseModel> state =
      ValueNotifier<UserCreateResponseModel>(
    UserCreateResponseModel(
      message: '',
      status: '',
      error: '',
      errors: {},
    ),
  );

  final ValueNotifier<String> erro = ValueNotifier<String>("");

  UserCreateStore({required this.repository});

  Future createUser(dynamic body, BuildContext context) async {
    isLoading.value = true;
    try {
      final result = await repository.createUser(body, context);
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isLoading.value = false;
  }

  Future updateUser(dynamic body, int id, BuildContext context) async {
    isLoading.value = true;
    try {
      final result = await repository.updateUser(body, id, context);
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isLoading.value = false;
  }
}
