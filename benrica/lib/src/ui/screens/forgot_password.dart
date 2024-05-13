import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late GlobalKey<FormState> _emailFormKey;
  late GlobalKey<FormState> _codeFormKey;
  late GlobalKey<FormState> _changePasswordFormKey;

  final _formData = <String, String>{};
  final UnderlineInputBorder underlineInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  );
  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;
  int step = 1;

  @override
  void initState() {
    super.initState();
    _emailFormKey = GlobalKey<FormState>();
    _codeFormKey = GlobalKey<FormState>();
    _changePasswordFormKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (step > 2) {
          setState(() {
            step--;
          });
        } else {
          return;
        }
        // if (company?.exclusive == 1) {
        //   return false;
        // }
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //     '/companies', (Route<dynamic> route) => false);
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
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => {
                      if (step > 2)
                        {
                          setState(() {
                            step--;
                          })
                        }
                      else
                        {Navigator.pop(context)}
                    }),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(
                16.0,
                16.0,
                16.0,
                MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context).viewInsets.bottom
                    : 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                step == 1
                    ? buildEmailStep()
                    : step == 2
                        ? buildCodeStep()
                        : buildChangePasswordStep(),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 60.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFD9D9D9)),
                  ),
                  onPressed: () {
                    setState(() {
                      step++;
                    });
                  },
                  child: const Text(
                    'CONTINUAR',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmailStep() {
    return Column(
      children: [
        const Text(
          'Digite seu E-mail para receber o código de verificação.',
        ),
        const SizedBox(
          height: 10.0,
        ),
        Form(
          key: _emailFormKey,
          child: Column(
            children: [
              buildTextFormField(
                formKey: _emailFormKey,
                formDataName: 'email',
                labelText: 'E-mail',
                keyboardType: TextInputType.emailAddress,
                regex: RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCodeStep() {
    return Column(
      children: [
        const Text(
          'Foi enviado um código de verificação para o e-mail gustavo@edrafox.com. Por favor, digite o código para continuar.',
        ),
        const SizedBox(
          height: 10.0,
        ),
        Form(
          key: _codeFormKey,
          child: Column(
            children: [
              buildTextFormField(
                formKey: _codeFormKey,
                formDataName: 'code',
                labelText: 'Código',
                keyboardType: TextInputType.number,
                minLength: 6,
                maxLength: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildChangePasswordStep() {
    return Column(
      children: [
        const Text(
          'Sua senha deve ter pelo menos 6 caracteres e deve incluir uma combinação de números, letras e caracteres especiais.',
        ),
        const SizedBox(
          height: 10.0,
        ),
        Form(
          key: _changePasswordFormKey,
          child: Column(
            children: [
              buildTextFormField(
                formKey: _changePasswordFormKey,
                formDataName: 'password',
                labelText: 'Nova senha',
                keyboardType: TextInputType.number,
                minLength: 6,
                maxLength: 8,
                obscure: isObscurePassword,
                onPressedObscure: () {
                  setState(() {
                    isObscurePassword = !isObscurePassword;
                  });
                },
              ),
              SizedBox(height: 10.0),
              buildTextFormField(
                formKey: _changePasswordFormKey,
                formDataName: 'confirm-password',
                labelText: 'Confirmar senha',
                keyboardType: TextInputType.number,
                minLength: 6,
                maxLength: 8,
                obscure: isObscureConfirmPassword,
                onPressedObscure: () {
                  setState(() {
                    isObscureConfirmPassword = !isObscureConfirmPassword;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextFormField({
    required GlobalKey<FormState> formKey,
    required String formDataName,
    required String labelText,
    required TextInputType keyboardType,
    int? minLength,
    int? maxLength,
    RegExp? regex,
    Function? onFieldSubmitted,
    bool? obscure,
    String? initialValue,
    String? valueToCompare,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onPressedObscure,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: maxLength ?? 50,
          initialValue: initialValue ?? '',
          inputFormatters: inputFormatters ?? [],
          decoration: InputDecoration(
            labelText: labelText,
            counterText: "",
            labelStyle: const TextStyle(color: Colors.black),
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            suffixIcon: obscure != null
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () => onPressedObscure!(),
                  )
                : null,
          ),
          obscureText: obscure ?? false,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardType,
          onSaved: (value) => _formData[formDataName] = value ?? '',
          onChanged: (value) {
            _formData[formDataName] = value;
            formKey.currentState?.save();
          },
          onFieldSubmitted: (value) {
            if (onFieldSubmitted != null) {
              onFieldSubmitted();
            }
          },
          validator: (newValue) {
            final value = newValue ?? '';
            if (value.trim().isEmpty) {
              return 'Campo obrigatório.';
            } else if (minLength != null && value.trim().length < minLength) {
              return 'Campo inválido.';
            } else if (regex != null && !regex.hasMatch(value)) {
              return 'Campo inválido.';
            } else if (valueToCompare != null && value != valueToCompare) {
              return "As senhas não coincidem.";
            }
            return null;
          },
        ),
      ),
    );
  }
}
