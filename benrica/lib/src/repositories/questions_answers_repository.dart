// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:benrica/src/domain/APIs/api_routes_url.dart';
import 'package:benrica/src/domain/http/exceptions.dart';
import 'package:benrica/src/domain/http/http_client.dart';
import 'package:benrica/src/domain/http/http_helper_replace.dart';
import 'package:benrica/src/domain/models/questions_answers_model.dart';
import 'package:benrica/src/ui/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class IQuestionsAnswersRepository {
  Future<List<QuestionsAnswersModel>> getQuestionsAnswers(BuildContext context);
}

class QuestionsAnswersRepository implements IQuestionsAnswersRepository {
  late final IHttpClient client;

  QuestionsAnswersRepository({required this.client});

  @override
  Future<List<QuestionsAnswersModel>> getQuestionsAnswers(
      BuildContext context) async {
    HelperHttp helper = HelperHttp();

    Map<String, dynamic> result =
        await helper.processUrl(ApiUrl.GET_QUESTIONS_ANSWERS);

    final response = await client.post(
        url: result['url'], headers: result['headers'], body: null);

    if (response.statusCode.toString().contains('20')) {
      final List<QuestionsAnswersModel> questionsAnswers = [];
      final body = jsonDecode(response.body);
      if (body['status'] != null && body['status'].toString().isNotEmpty) {
        CustomSnackBar.show(
          context,
          'Você será desconectado em breve!',
          success: false,
        );
        context.pushReplacement('/login');
        return questionsAnswers;
      } else {
        for (var item in (body['questions'] as List)) {
          final QuestionsAnswersModel questionAnswer =
              QuestionsAnswersModel.fromMap(item);
          questionsAnswers.add(questionAnswer);
        }
        return questionsAnswers;
      }
    } else if (response.statusCode.toString().contains('40')) {
      throw NotFoundException('A url informada não é válida');
    } else {
      throw Exception('Não foi possível carregar');
    }
  }
}
