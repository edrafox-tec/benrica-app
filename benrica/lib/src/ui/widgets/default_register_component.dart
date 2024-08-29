import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DefaultRegisterComponent extends StatefulWidget {
  final Function(Map<String, dynamic>) returnDefaultPageResult;
  bool isLoading;

  DefaultRegisterComponent({
    required this.returnDefaultPageResult,
    required this.isLoading,
  });

  @override
  State<DefaultRegisterComponent> createState() =>
      _DefaultRegisterComponentState();
}

class _DefaultRegisterComponentState extends State<DefaultRegisterComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  final UnderlineInputBorder underlineInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  );
  double keyboardHeight = 0.0;
  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;
  bool isLoading = false;

  @override
  void didUpdateWidget(DefaultRegisterComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      print(isLoading);
      setState(() {
        isLoading = widget.isLoading;
      });
    }
  }

  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
    mask: '(##) # ####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final List<TextInputFormatter> phoneMaskFormatter = [
    MaskTextInputFormatter(
      mask: '(##) # ####-####',
      filter: {"#": RegExp(r'[0-9]')},
    ),
  ];

  void _returnControllersMapToParent() {
    final isValid = _formKey.currentState?.validate() ?? false;
    _formKey.currentState?.save();
    print(_formData['password'] != _formData['confirm_password']);
    print([_formData['password'], _formData['confirm_password']]);
    if (!isValid && _formData['password'] != _formData['confirm_password'] ||
        isLoading == true) {
      return;
    }
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    _formData['all_answers'] = null;
    _formData['id_businesses'] = 0;
    _formData['access_level'] = 0;
    _formData['phone_number'] =
        _formData['phone_number'].replaceAll(RegExp(r'[\s()-]'), '');
    widget.returnDefaultPageResult(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + keyboardHeight,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextFormField(
                formDataName: 'user_name',
                labelText: 'Nome',
                keyboardType: TextInputType.name,
                minLength: 5,
              ),
              const SizedBox(height: 10.0),
              buildTextFormField(
                formDataName: 'email',
                labelText: 'E-mail',
                keyboardType: TextInputType.emailAddress,
                regex: RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"),
              ),
              const SizedBox(height: 10.0),
              buildTextFormField(
                formDataName: 'phone_number',
                labelText: 'Telefone',
                keyboardType: TextInputType.phone,
                minLength: 16,
                inputFormatters: phoneMaskFormatter,
              ),
              const SizedBox(height: 10.0),
              buildTextFormField(
                formDataName: 'password',
                labelText: 'Senha',
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
                formDataName: 'confirm_password',
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
                onFieldSubmitted: _returnControllersMapToParent,
                valueToCompare: _formData['password'],
              ),
              const SizedBox(height: 20.0),
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
                    const Color(0xFFD9D9D9),
                  ),
                ),
                onPressed: () => _returnControllersMapToParent(),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const Text(
                        'PRÓXIMO',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 20.0),
            ],
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
