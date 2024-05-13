// ignore_for_file: use_build_context_synchronously

import 'package:benrica/src/domain/APIs/api_routes_url.dart';
import 'package:benrica/src/domain/http/http_client.dart';
import 'package:benrica/src/domain/models/company_model.dart';
import 'package:benrica/src/domain/models/user_create_model.dart';
import 'package:benrica/src/domain/repositories/questions_answers_repository.dart';
import 'package:benrica/src/domain/repositories/user_create_repository.dart';
import 'package:benrica/src/domain/stores/questions_answers_store.dart';
import 'package:benrica/src/domain/stores/user_store.dart';
import 'package:benrica/src/domain/ultis/shared_preferences_helper.dart';
import 'package:benrica/src/ui/widgets/custom_snack_bar.dart';
import 'package:benrica/src/ui/widgets/default_register_component.dart';
import 'package:benrica/src/ui/widgets/dynamic_register_component.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  final ApiUrl apiUrl = ApiUrl();

  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  UserCreateModel data = UserCreateModel(
      user_name: '',
      email: '',
      phone_number: '',
      id_businesses: null,
      password: '',
      access_level: null,
      all_answers: []);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CompanyModel? company;
  BuildContext? contexts;
  int steps = 1;
  int step = 1;

  final QuestionsAnswersStore questionsAnswers = QuestionsAnswersStore(
    repository: QuestionsAnswersRepository(
      client: HttpClientAdapter(),
    ),
  );

  @override
  void initState() {
    super.initState();
    contexts = context;
    getData();
  }

  Future<void> getData() async {
    final response = await SharedPreferencesHelper.getData(
      'company',
      (json) => CompanyModel.fromMap(json),
    );
    company = response;
    print(company?.exclusive);
    if (company?.exclusive == 1) {
      questionsAnswers.getQuestionsAnswers(context).then((_) {
        if (questionsAnswers.state.value.isNotEmpty) {
          steps = 2;
        }
      });
    } else {
      steps = 1;
      step = 1;
    }
  }

  final UserCreateStore user = UserCreateStore(
    repository: UserCreateRepository(
      client: HttpClientAdapter(),
    ),
  );

  void createUser(
    dynamic body,
    BuildContext context,
  ) async {
    try {
      await user.createUser(body, context);
      if (user.state.value.message ==
          "Usuário e respostas salvas com sucesso") {
        CustomSnackBar.show(context, 'Usuário cadastrado com sucesso',
            success: true);
        this.context.push('/login');
      } else {
        CustomSnackBar.show(
          context,
          'Erro ao cadastrar cliente',
          success: false,
        );
      }
    } catch (e) {
      print('Error during login: $e');
      CustomSnackBar.show(
        context,
        'Erro inesperado durante a autenticação',
        success: false,
      );
    }
  }

  void getDefaultPageResult(Map<String, dynamic> map) {
    print('voltou getDefaultPageResult');
    print(map);
    if (map['all_answers'] == null) {
      map['all_answers'] = [];
    }
    data = UserCreateModel.fromMap(map);

    if (company?.exclusive == 1) {
      setState(() {
        step = 2;
      });
    } else {
      data = UserCreateModel(
        user_name: data.user_name,
        email: data.email,
        phone_number: data.phone_number,
        password: data.password,
        id_businesses: company?.id,
        access_level: 0,
        all_answers: [],
      );
      print(data.toString());
      createUser(data.toJson(), context);
    }
  }

  void getDynamicPageResult(Map<String, dynamic> map) {
    print('voltou getDynamicPageResult');
    List<AnswersCreateModel> newAnswers = [];
    for (var entry in map.entries) {
      String questionId = entry.key; //Pegando o id da pergunta
      String type = questionsAnswers.state.value
          .firstWhere((element) => element.id.toString() == questionId)
          .question_type; //Pegando o tipo da pergunta
      dynamic answerValue =
          entry.value; //Pegando a resposta da pergunta sem validar
      if (type == "date") {
        //Verificando se é uma data e fazendo devidas modificações
        List<String> parts = answerValue.split('/');
        answerValue = '${parts[2]}-${parts[1]}-${parts[0]}';
      }
      if (type == "checkbox") {
        //Verificando se é uma checkbox e fazendo devidas modificações
        List<String> numbers =
            answerValue.replaceAll('[', '').replaceAll(']', '').split(', ');
        List<int> intNumbers =
            numbers.map((number) => int.parse(number)).toList();
        for (var element in intNumbers) {
          //Verificando ha mais de um checkbox
          AnswersCreateModel answer = AnswersCreateModel(
            question_id: questionId,
            answer: element.toString(),
            type: type,
          );
          newAnswers.add(answer);
        }
      } else {
        AnswersCreateModel answer = AnswersCreateModel(
            question_id: questionId,
            answer: answerValue.toString(),
            type: type);
        newAnswers.add(answer);
      }
    }

    List<AnswersCreateModel>? mergedAnswers = [];
    mergedAnswers.addAll(data.all_answers ?? []);
    mergedAnswers.addAll(newAnswers);

    data = UserCreateModel(
      user_name: data.user_name,
      email: data.email,
      phone_number: data.phone_number,
      password: data.password,
      id_businesses: company?.id,
      access_level: 0,
      all_answers: mergedAnswers,
    );
    print(data.toString());
    createUser(data.toJson(), context);
  }

  Future<void> showExitDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Tem certeza que deseja sair?',
            style: TextStyle(fontSize: 14),
          ),
          content: const Text(
            "Você perderá todos os seus dados preenchidos.",
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                context.pop();
              },
            ),
            TextButton(
              child: Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              onPressed: () {
                context.pop();
                context.pushReplacement('/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).primaryColor;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (step == 2) {
          setState(() {
            step = 1;
          });
        } else {
          showExitDialog(context);
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => {
                      if (step == 2)
                        {
                          setState(() {
                            step = 1;
                          })
                        }
                      else
                        {showExitDialog(context)}
                    }),
          ),
          body: AnimatedBuilder(
              animation: Listenable.merge([
                questionsAnswers.isLoading,
                questionsAnswers.erro,
                questionsAnswers.state,
                user.isLoading,
              ]),
              builder: (context, child) {
                if (questionsAnswers.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (questionsAnswers.erro.value.isNotEmpty) {
                  Future.delayed(Duration.zero, () {
                    CustomSnackBar.show(
                      context,
                      'Erro inesperado. Tente novamente mais tarde!',
                      success: false,
                    );
                  });
                }

                if (questionsAnswers.state.value.isEmpty && steps != 1) {
                  return const Center(
                    child: Text(
                      "Nenhum item na lista",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cadastre-se',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Etapa $step de $steps',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              LinearProgressIndicator(
                                color: const Color(0xFF40B146),
                                value: (step / steps),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                          Expanded(
                            // child: false
                            child: step == 1 || steps == 1
                                ? DefaultRegisterComponent(
                                    returnDefaultPageResult:
                                        getDefaultPageResult,
                                    isLoading: user.isLoading.value,
                                  )
                                : DynamicRegisterComponent(
                                    questionsAnswers:
                                        questionsAnswers.state.value,
                                    returnDynamicPageResult:
                                        getDynamicPageResult,
                                    isLoading: user.isLoading.value,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              })),
    );
  }
}
