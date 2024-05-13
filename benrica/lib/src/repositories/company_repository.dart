// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:benrica/src/domain/APIs/api_routes_url.dart';
import 'package:benrica/src/domain/http/exceptions.dart';
import 'package:benrica/src/domain/http/http_client.dart';
import 'package:benrica/src/domain/http/http_helper_replace.dart';
import 'package:benrica/src/domain/models/company_model.dart';
import 'package:benrica/src/ui/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class ICompanyRepository {
  Future<List<CompanyModel>> getCompany(BuildContext context);
}

class CompanyRepository implements ICompanyRepository {
  late final IHttpClient client;

  CompanyRepository({required this.client});

  @override
  Future<List<CompanyModel>> getCompany(BuildContext context) async {
    HelperHttp helper = HelperHttp();

    Map<String, dynamic> result = await helper.processUrl(ApiUrl.GET_COMPANIES);

    final response = await client.post(
        url: result['url'], headers: result['headers'], body: null);

    if (response.statusCode.toString().contains('20')) {
      final List<CompanyModel> companies = [];
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
            return companies;
          } else {
            final CompanyModel company = CompanyModel.fromMap(item);
            companies.add(company);
          }
        }
        return companies;
      } else if (body is Map &&
          body['status'] != null &&
          body['status'].toString().isNotEmpty) {
        CustomSnackBar.show(
          context,
          'Você será desconectado em breve!',
          success: false,
        );
        context.pushReplacement('/companies');
        return companies;
      } else {
        throw Exception('Resposta inesperada');
      }
    } else if (response.statusCode.toString().contains('40')) {
      throw NotFoundException('A url informada não é válida');
    } else {
      throw Exception('Não foi possível carregar');
    }
  }
}
