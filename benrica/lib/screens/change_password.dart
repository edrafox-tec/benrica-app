import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, String>{};
  final UnderlineInputBorder underlineInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  );
  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // if (company?.exclusive == 1) {
        //   return false;
        // }
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //     '/companies', (Route<dynamic> route) => false);
        // return true;
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
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0,
                MediaQuery.of(context).viewInsets.bottom + 16.0),
            child: Column(
              children: [
                const Text(
                  'Sua senha deve ter pelo menos 6 caracteres e deve incluir uma combinação de números, letras e caracteres especiais.',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextFormField(
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
                      const SizedBox(height: 10.0),
                      buildTextFormField(
                        formDataName: 'confirm-password',
                        labelText: 'Confirmar senha',
                        keyboardType: TextInputType.number,
                        minLength: 6,
                        maxLength: 8,
                        obscure: isObscureConfirmPassword,
                        onPressedObscure: () {
                          setState(() {
                            isObscureConfirmPassword =
                                !isObscureConfirmPassword;
                          });
                        },
                      ),
                    ],
                  ),
                ),
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
                  onPressed: () {},
                  child: const Text(
                    'ALTERAR',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // ElevatedButton(
                //   style: ButtonStyle(
                //     minimumSize: MaterialStateProperty.all(
                //         const Size(double.infinity, 60.0)),
                //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //       RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //     backgroundColor: MaterialStateProperty.all<Color>(
                //         const Color(0xFFD9D9D9)),
                //   ),
                //   onPressed: () {

                //   },
                //   child: AnimatedBuilder(
                //     animation: Listenable.merge([
                //       login.isLoading,
                //       login.erro,
                //       login.state,
                //     ]),
                //     builder: (context, child) {
                //       if (login.isLoading.value) {
                //         return const Center(child: CircularProgressIndicator());
                //       } else {
                //         return const Text(
                //           'ENTRAR',
                //           style: TextStyle(
                //             color: Colors.black,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         );
                //       }
                //     },
                //   ),
                // ),
                const SizedBox(height: 30.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
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

  Widget buildTextFormField({
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
            _formKey.currentState?.save();
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
              return "As senhas não se coincidem.";
            }
            return null;
          },
        ),
      ),
    );
  }
}
