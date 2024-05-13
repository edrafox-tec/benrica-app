// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:benrica/src/domain/http/exceptions.dart';
import 'package:benrica/src/domain/http/http_client.dart';
import 'package:benrica/src/domain/http/http_helper_replace.dart';
import 'package:benrica/src/domain/models/schedule_model.dart';
import 'package:benrica/src/domain/ultis/api_url.dart';
import 'package:benrica/src/ui/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class IScheduleRepository {
  Future<List<ScheduleModel>> getSchedule(BuildContext context);
  Future<List<ScheduleModel>> addSchedule(dynamic body, BuildContext context);
}

class ScheduleRepository implements IScheduleRepository {
  late final IHttpClient client;

  ScheduleRepository({required this.client});

  @override
  Future<List<ScheduleModel>> getSchedule(BuildContext context) async {
    HelperHttp helper = HelperHttp();

    Map<String, dynamic> result =
        await helper.processUrl(ApiUrl.GET_STORE_SCHEDULE);

    final response = await client.post(
        url: result['url'], headers: result['headers'], body: null);

    if (response.statusCode.toString().contains('20')) {
      final List<ScheduleModel> schedules = [];
      final body = jsonDecode(response.body);

      if (body is List) {
        for (var item in body) {
          if (item is Map && item['status'] != null) {
            CustomSnackBar.show(
              context,
              'Você será desconectado em breve!',
              success: false,
            );
            context.pushReplacement('/login');

            return schedules;
          } else {
            final ScheduleModel schedule = ScheduleModel.fromMap(item);
            schedules.add(schedule);
          }
        }
        return schedules;
      } else if (body is Map &&
          body['status'] != null &&
          body['status'].toString().isNotEmpty) {
        CustomSnackBar.show(
          context,
          'Você será desconectado em breve!',
          success: false,
        );
        context.pushReplacement('/login');
        return schedules;
      } else {
        throw Exception('Resposta inesperada');
      }
    } else if (response.statusCode.toString().contains('40')) {
      throw NotFoundException('A url informada não é válida');
    } else {
      throw Exception('Não foi possível carregar');
    }
  }

  @override
  Future<List<ScheduleModel>> addSchedule(
      dynamic body, BuildContext context) async {
    HelperHttp helper = HelperHttp();

    Map<String, dynamic> result = await helper.processUrl(ApiUrl.ADD_SCHEDULE);

    final response = await client.post(
        url: result['url'], headers: result['headers'], body: body);

    if (response.statusCode.toString().contains('20')) {
      final List<ScheduleModel> schedules = [];
      final body = jsonDecode(response.body);

      if (body is Map && body['scheduling'] != null) {
        var schedulingData = body['scheduling'];
        final schedule = ScheduleModel.fromMap(schedulingData);
        schedules.add(schedule);
      } else if (body is Map &&
          body['status'] != null &&
          body['status'].toString().isNotEmpty) {
        CustomSnackBar.show(
          context,
          'Você será desconectado em breve!',
          success: false,
        );
        context.pushReplacement('/login');
      } else {
        throw Exception('Resposta inesperada');
      }
      return schedules;
    } else if (response.statusCode.toString().contains('40')) {
      throw NotFoundException('A url informada não é válida');
    } else {
      throw Exception('Não foi possível carregar');
    }
  }
}
