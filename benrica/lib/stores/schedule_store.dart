import 'package:benrica/http/exceptions.dart';
import 'package:benrica/models/schedule_model.dart';
import 'package:benrica/repositories/schedule_repository.dart';
import 'package:flutter/material.dart';

class ScheduleStore {
  final IScheduleRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final ValueNotifier<List<ScheduleModel>> state =
      ValueNotifier<List<ScheduleModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>("");

  ScheduleStore({required this.repository});

  Future getSchedule(BuildContext context) async {
    isLoading.value = true;
    try {
      final result = await repository.getSchedule(context);
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isLoading.value = false;
  }

  Future addSchedule(dynamic body, BuildContext context) async {
    isLoading.value = true;
    try {
      final result = await repository.addSchedule(body, context);
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isLoading.value = false;
  }
}
