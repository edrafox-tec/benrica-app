// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:benrica/src/domain/http/exceptions.dart';
import 'package:benrica/src/domain/http/http_client.dart';
import 'package:benrica/src/domain/http/http_helper_replace.dart';
import 'package:benrica/src/domain/models/login_model.dart';
import 'package:benrica/src/domain/ultis/api_url.dart';
import 'package:benrica/src/ui/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class ILoginRepository {
  Future<LoginModel> doLogin(dynamic body, BuildContext context);
}

class LoginRepository implements ILoginRepository {
  late final IHttpClient client;

  LoginRepository({required this.client});

  @override
  Future<LoginModel> doLogin(dynamic body, BuildContext context) async {
    HelperHttp helper = HelperHttp();

    Map<String, dynamic> result = await helper.processUrl(ApiUrl.LOGIN);

    final response = await client.post(
        url: result['url'], headers: result['headers'], body: body);

    if (response.statusCode.toString().contains('20')) {
      final body = jsonDecode(response.body);
      if (body['status'] != null && body['status'].toString().isNotEmpty) {
        print(body.toString());
        CustomSnackBar.show(
          context,
          'Você será desconectado em breve!',
          success: false,
        );
        context.pushReplacement('/login');
        throw Exception('Não foi possível carregar');
      } else {
        return LoginModel.fromMap(body);
      }
    } else if (response.statusCode.toString().contains('40')) {
      throw NotFoundException('A url informada não é válida');
    } else {
      throw Exception('Não foi possível carregar');
    }
  }
}
