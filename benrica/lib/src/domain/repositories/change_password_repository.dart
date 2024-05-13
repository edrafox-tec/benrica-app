// // ignore_for_file: use_build_context_synchronously

// import 'dart:convert';

// import 'package:benrica/components/custom_snack_bar.dart';
// import 'package:benrica/http/exceptions.dart';
// import 'package:benrica/http/http_client.dart';
// import 'package:benrica/http/http_helper_replace.dart';
// import 'package:benrica/models/company_model.dart';
// import 'package:benrica/ultis/api_url.dart';
// import 'package:flutter/material.dart';

// abstract class IChangePasswordRepository {
//   Future CompanyModel changePassword(dynamic body,BuildContext context);
// }

// class ChangePasswordRepository implements IChangePasswordRepository {
//   late final IHttpClient client;

//   ChangePasswordRepository({required this.client});

//   @override
//   Future CompanyModel changePassword(dynamic body,BuildContext context) async {
//     HelperHttp helper = HelperHttp();

//     Map<String, dynamic> result = await helper.processUrl(ApiUrl.GET_COMPANIES);

//     final response = await client.post(
//         url: result['url'], headers: result['headers'], body: body);

//     if (response.statusCode.toString().contains('20')) {
//       final CompanyModel companies = {};
//       final body = jsonDecode(response.body);

//       if (body is List) {
//         for (var item in body) {
//           if (item is Map && item['status'] != null) {
//             CustomSnackBar.show(
//               context,
//               'Você será desconectado em breve!',
//               success: false,
//             );
//             Navigator.of(context).pushNamedAndRemoveUntil(
//                 '/login', (Route<dynamic> route) => false);
//             return companies;
//           } else {
//             final CompanyModel company = CompanyModel.fromMap(item);
//             companies.add(company);
//           }
//         }
//         return companies;
//       } else if (body is Map &&
//           body['status'] != null &&
//           body['status'].toString().isNotEmpty) {
//         CustomSnackBar.show(
//           context,
//           'Você será desconectado em breve!',
//           success: false,
//         );
//         Navigator.of(context).pushNamedAndRemoveUntil(
//             '/companies', (Route<dynamic> route) => false);
//         return companies;
//       } else {
//         throw Exception('Resposta inesperada');
//       }
//     } else if (response.statusCode.toString().contains('40')) {
//       throw NotFoundException('A url informada não é válida');
//     } else {
//       throw Exception('Não foi possível carregar');
//     }
//   }
// }
