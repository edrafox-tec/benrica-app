// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:benrica/src/domain/APIs/api_routes_url.dart';
import 'package:benrica/src/domain/http/http_client.dart';
import 'package:benrica/src/domain/models/company_model.dart';
import 'package:benrica/src/domain/models/login_model.dart';
import 'package:benrica/src/domain/repositories/login_repository.dart';
import 'package:benrica/src/domain/services/shared_preferences_service.dart';
import 'package:benrica/src/domain/stores/login_store.dart';
import 'package:benrica/src/ui/widgets/custom_snack_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginFormData {
  final int id;
  final String email;
  final String password;

  LoginFormData({
    required this.id,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  factory LoginFormData.fromJson(Map<String, dynamic> map) {
    return LoginFormData(
      id: map['id'] as int,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }
}

class LoginPage extends StatefulWidget {
  final ApiUrl apiUrl = ApiUrl();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  CompanyModel? company;
  String baseUrlImg = '${ApiUrl.URL_IMAGE}businesses/';
  bool _isObscure = true;
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  final LoginStore login = LoginStore(
    repository: LoginRepository(
      client: HttpClientAdapter(),
    ),
  );

  final UnderlineInputBorder underlineInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  );

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final jsonString = await _sharedPreferencesService.getSharedData('company');
    final jsonLoginFormData =
        await _sharedPreferencesService.getSharedData('loginFormData');

    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      company = CompanyModel.fromMap(jsonMap);
      if (company != null && company?.logo_img != null) {
        setState(() {
          baseUrlImg += company?.logo_img ?? '';
        });
      }
    }

    if (jsonLoginFormData != null && company != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonLoginFormData);
      final loginFormDataId = int.tryParse(jsonMap['id'].toString());
      if (loginFormDataId != null && company!.id == loginFormDataId) {
        final loginFormData = LoginFormData.fromJson(jsonMap);
        setState(() {
          _emailController.text = loginFormData.email;
          _passwordController.text = loginFormData.password;
        });
        _onSubmittedLogin(context);
      }
    }
  }

  void _onSubmittedLogin(BuildContext context) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || login.isLoading.value) {
      return;
    }
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    _formKey.currentState?.save();
    try {
      await login.doLogin({
        'email': _emailController.text,
        'password': _passwordController.text,
      }, context);

      if (login.state.value.error?.isEmpty == true &&
          login.state.value.access_token!.isEmpty) {
        CustomSnackBar.show(
          context,
          'Erro inesperado durante a autenticação',
          success: false,
        );
      } else if (login.state.value.error?.isEmpty == true) {
        CustomSnackBar.show(context, 'Email ou senha inválidos.',
            success: false);
      } else {
        if (login.state.value.user?.access_level == 0 &&
            login.state.value.user?.id_businesses == company?.id) {
          saveLoginData(login.state.value);
        } else {
          CustomSnackBar.show(context, 'Usuário não autorizado!',
              success: false);
        }
      }
    } catch (e) {
      CustomSnackBar.show(
        context,
        'Erro inesperado durante a autenticação',
        success: false,
      );
    }
  }

  void saveLoginData(LoginModel data) async {
    CustomSnackBar.show(context, 'Login realizado com sucesso!', success: true);
    LoginModel loginData = data;
    String cleanedToken = loginData.access_token!.replaceAllMapped(
      RegExp(r'^"(.*)"$'),
      (match) => match.group(1) ?? '',
    );

    // Salvando os dados no SharedPreferences
    await _sharedPreferencesService.saveSharedData(
      'loginResponse',
      jsonEncode(loginData.toJson()),
    );
    await _sharedPreferencesService.saveSharedData('token', cleanedToken);
    await _sharedPreferencesService.saveSharedData(
      'user',
      jsonEncode(loginData.user!.toJson()),
    );
    LoginFormData formData = LoginFormData(
      id: loginData.user!.id_businesses,
      email: _emailController.text,
      password: _passwordController.text,
    );
    await _sharedPreferencesService.saveSharedData(
      'loginFormData',
      jsonEncode(formData.toJson()),
    );

    context.pushReplacement('/logged');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (company?.exclusive != 1) {
          context.pushReplacement('/companies');
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: company != null && company?.exclusive != 1
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () async {
                      await _sharedPreferencesService
                          .removeSharedData('id_business');
                      context.pushReplacement('/companies');
                    },
                  )
                : null,
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0,
                MediaQuery.of(context).viewInsets.bottom + 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: baseUrlImg,
                    width: 200,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/logo/benrica_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          child: TextFormField(
                            controller: _emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.black),
                              enabledBorder: underlineInputBorder,
                              focusedBorder: underlineInputBorder,
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (email) {
                              final value = email ?? '';
                              if (value.trim().isEmpty) {
                                return 'Campo obrigatório.';
                              } else if (value.trim().length < 6 ||
                                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                      .hasMatch(value)) {
                                return 'Email inválido.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          child: TextFormField(
                            controller: _passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              labelStyle: const TextStyle(color: Colors.black),
                              enabledBorder: underlineInputBorder,
                              focusedBorder: underlineInputBorder,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                            obscureText: _isObscure,
                            onSaved: (password) =>
                                _passwordController.text = password ?? '',
                            validator: (password) {
                              final value = password ?? '';
                              if (value.isEmpty) {
                                return 'Campo obrigatório.';
                              } else if (value.trim().length < 6) {
                                return 'Senha muito curta.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _onSubmittedLogin(context),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Entrar'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
