// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:benrica/components/custom_snack_bar.dart';
import 'package:benrica/http/http_client.dart';
import 'package:benrica/models/user_model.dart';
import 'package:benrica/repositories/user_create_repository.dart';
import 'package:benrica/stores/user_store.dart';
import 'package:benrica/ultis/api_url.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditUserPage extends StatefulWidget {
  UserResponseInterface? user;

  EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  bool showErrors = false;
  bool loadingPhoto = false;
  final _formKey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();
  String newImage = '';
  String userImage = '';

  final UserCreateStore user = UserCreateStore(
    repository: UserCreateRepository(
      client: HttpClientAdapter(),
    ),
  );

  Map<String, TextEditingController> controllers = {
    'user_name': TextEditingController(),
    'email': TextEditingController(),
    'phone_number': TextEditingController(),
  };

  final List<TextInputFormatter> phoneMaskFormatter = [
    MaskTextInputFormatter(
      mask: '(##) # ####-####',
      filter: {"#": RegExp(r'[0-9]')},
    ),
  ];

  String applyMask(String value, List<TextInputFormatter> formatters) {
    String result = value;
    for (var formatter in formatters) {
      result = formatter
          .formatEditUpdate(
              TextEditingValue.empty, TextEditingValue(text: result))
          .text;
    }
    return result;
  }

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      controllers['user_name']!.text = widget.user!.user_name;
      controllers['email']!.text = widget.user!.email;
      controllers['phone_number']!.text =
          applyMask(widget.user!.phone_number, phoneMaskFormatter);
      if (widget.user?.photo != null && widget.user!.photo!.isNotEmpty) {
        userImage = '${ApiUrl.URL_IMAGE}businesses/${widget.user!.photo!}';
      }
    }
  }

  void updateUser(
    BuildContext context,
  ) async {
    String? photo;
    photo = userImage.contains(ApiUrl.URL_IMAGE)
        ? photo = userImage
        : userImage.length > 20
            ? photo = 'data:image/jpeg;base64,$userImage'
            : null;
    final body = {
      'user_name': controllers['user_name']!.text,
      'email': controllers['email']!.text,
      'phone_number': controllers['phone_number']!.text,
      'photo': photo,
    };
    try {
      await user.updateUser(body, widget.user!.id, context);
      print(user.state);
      print(user.state.value);
      if (user.state.value.error?.isEmpty == true) {
        CustomSnackBar.show(
          context,
          'Erro inesperado durante a atualização do usuário.',
          success: false,
        );
      } else {
        CustomSnackBar.show(context, 'Atualização realizada com sucesso!',
            success: true);
        context.pop();
      }
    } catch (e) {
      print('Error during login: $e');
      CustomSnackBar.show(
        context,
        'Erro inesperado durante a autenticação',
        success: false,
      );
    } finally {
      setState(() {});
    }
  }

  Widget buildUserImage() {
    return InkWell(
      onTap: _showOptionsBottomSheet,
      child: loadingPhoto
          ? const CircularProgressIndicator()
          : newImage == '' && userImage == ''
              ? Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Color(0xFF474545),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: -10,
                      right: -10,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.white,
                        onPressed: null,
                      ),
                    ),
                  ],
                )
              : newImage != ''
                  ? Center(
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: MemoryImage(
                                    base64Decode(newImage),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            top: -10,
                            right: -10,
                            child: IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.white,
                              onPressed: null,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(userImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            top: -10,
                            right: -10,
                            child: IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.white,
                              onPressed: null,
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\(\d{2}\) 9 \d{4}-\d{4}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  pick(ImageSource source) async {
    setState(() {
      loadingPhoto = true;
    });
    final pickedFile = await imagePicker.pickImage(
        source: source, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      String imageType = pickedFile.mimeType ?? 'image/jpeg';
      String base64Image = '';
      if (kIsWeb) {
        var imageBytes = await pickedFile.readAsBytes();
        // base64Image = 'data:$imageType;base64,${base64Encode(imageBytes)}';
        base64Image = base64Encode(imageBytes);
      } else {
        List<int> imageBytes = File(pickedFile.path).readAsBytesSync();
        // base64Image = 'data:$imageType;base64,${base64Encode(imageBytes)}';
        base64Image = base64Encode(imageBytes);
      }
      setState(() {
        newImage = base64Image;
      });
    }
    setState(() {
      loadingPhoto = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            16.0, 16.0, 16.0, MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            buildUserImage(),
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        buildTextFormField(
                          controller: controllers['user_name']!,
                          keyboardType: TextInputType.name,
                          labelText: 'Nome',
                          validator: (value) {
                            if (showErrors && value!.isEmpty) {
                              return 'Campo obrigatório.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        buildTextFormField(
                          controller: controllers['email']!,
                          keyboardType: TextInputType.emailAddress,
                          labelText: 'E-mail',
                          validator: (value) {
                            if (showErrors) {
                              if (value!.isEmpty) {
                                return 'Campo obrigatório.';
                              } else if (!_isValidEmail(value)) {
                                return 'Por favor, insira um e-mail válido.';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        buildTextFormField(
                          controller: controllers['phone_number']!,
                          keyboardType: TextInputType.phone,
                          formatters: phoneMaskFormatter,
                          usePhoneMask: true,
                          labelText: 'Telefone',
                          validator: (value) {
                            if (showErrors) {
                              if (value!.isEmpty) {
                                return 'Campo obrigatório.';
                              } else if (!_isValidPhoneNumber(value)) {
                                return 'Por favor, insira um número de telefone válido no formato (31) 9 1234-5678.';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                            const Size(double.infinity, 60.0)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFFD9D9D9)),
                      ),
                      onPressed: () {
                        setState(() {
                          showErrors = true;
                        });
                        _formKey.currentState?.validate();
                        bool allFieldsFilled = true;
                        for (var element in controllers.values) {
                          if (element.text.isEmpty) {
                            allFieldsFilled = false;
                            break;
                          }
                        }
                        if (allFieldsFilled) {
                          updateUser(context);
                        }
                      },
                      child: user.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text(
                              'ALTERAR',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    List<TextInputFormatter>? formatters,
    required String labelText,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    bool usePhoneMask = true,
    Function(String)? onChanged,
  }) {
    List<TextInputFormatter> inputFormatters = formatters ?? [];

    return Card(
      color: const Color.fromRGBO(203, 203, 203, 0.85),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                labelText: labelText,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                suffixIcon: suffixIcon,
              ),
              validator: validator,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  context.pop();
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  context.pop();
                  pick(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
