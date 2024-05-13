import 'package:benrica/src/domain/http/exceptions.dart';
import 'package:benrica/src/domain/models/service_model.dart';
import 'package:benrica/src/domain/repositories/service_repository.dart';
import 'package:flutter/material.dart';

class ServiceStore {
  final IServiceRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final ValueNotifier<List<ServiceModel>> state =
      ValueNotifier<List<ServiceModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>("");

  ServiceStore({required this.repository});

  Future getService(BuildContext context) async {
    isLoading.value = true;
    try {
      final result = await repository.getService(context);
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isLoading.value = false;
  }
}
