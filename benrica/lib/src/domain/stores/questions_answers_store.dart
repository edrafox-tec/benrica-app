import 'package:benrica/src/domain/http/exceptions.dart';
import 'package:benrica/src/domain/models/questions_answers_model.dart';
import 'package:benrica/src/domain/repositories/questions_answers_repository.dart';
import 'package:flutter/material.dart';

class QuestionsAnswersStore {
  final IQuestionsAnswersRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final ValueNotifier<List<QuestionsAnswersModel>> state =
      ValueNotifier<List<QuestionsAnswersModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>("");

  QuestionsAnswersStore({required this.repository});

  Future getQuestionsAnswers(BuildContext context) async {
    isLoading.value = true;
    try {
      final result = await repository.getQuestionsAnswers(context);
      print(result);
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}
