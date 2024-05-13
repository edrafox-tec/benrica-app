import 'package:benrica/src/domain/http/exceptions.dart';
import 'package:benrica/src/domain/models/company_model.dart';
import 'package:benrica/src/domain/repositories/company_repository.dart';
import 'package:flutter/material.dart';

class CompanyStore {
  final ICompanyRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final ValueNotifier<List<CompanyModel>> state =
      ValueNotifier<List<CompanyModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>("");

  CompanyStore({required this.repository});

  Future getCompany(BuildContext context) async {
    isLoading.value = true;
    try {
      final result = await repository.getCompany(context);
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isLoading.value = false;
  }
}
