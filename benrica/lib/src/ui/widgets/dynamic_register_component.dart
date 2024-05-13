import 'dart:convert';
import 'dart:io';

import 'package:benrica/src/domain/models/questions_answers_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DynamicRegisterComponent extends StatefulWidget {
  final List<QuestionsAnswersModel> questionsAnswers;
  final Function(Map<String, dynamic>) returnDynamicPageResult;
  bool isLoading;

  DynamicRegisterComponent({
    super.key,
    required this.questionsAnswers,
    required this.returnDynamicPageResult,
    required this.isLoading,
  });

  @override
  State<DynamicRegisterComponent> createState() =>
      _DynamicRegisterComponentState();
}

class _DynamicRegisterComponentState extends State<DynamicRegisterComponent> {
  final imagePicker = ImagePicker();
  late List<GlobalKey<FormState>> keys;
  Map<String, TextEditingController> controllers = {};
  Map<String, List<String>> selectedOptions = {};
  bool showErrors = false;
  double keyboardHeight = 0.0;
  final List<TextInputFormatter> phoneMaskFormatter = [
    MaskTextInputFormatter(
      mask: '(##) # ####-####',
      filter: {"#": RegExp(r'[0-9]')},
    ),
  ];

  bool isLoading = false;

  @override
  void didUpdateWidget(DynamicRegisterComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      print(isLoading);
      print(isLoading);
      setState(() {
        isLoading = widget.isLoading;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print(isLoading);
    keys = List.generate(
        widget.questionsAnswers.length, (_) => GlobalKey<FormState>());
    for (var question in widget.questionsAnswers) {
      if (question.question_type == "select") {
        selectedOptions[question.id.toString()] = [""];
      }
      controllers[question.id.toString()] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  pick(ImageSource source, String id) async {
    final pickedFile = await imagePicker.pickImage(
        source: source, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      String imageType = pickedFile.mimeType ?? 'image/jpeg';
      String base64Image = '';
      if (kIsWeb) {
        var imageBytes = await pickedFile.readAsBytes();
        base64Image = 'data:$imageType;base64,${base64Encode(imageBytes)}';
      } else {
        List<int> imageBytes = File(pickedFile.path).readAsBytesSync();
        base64Image = 'data:$imageType;base64,${base64Encode(imageBytes)}';
      }
      setState(() {
        // controllers[id]?.text = pickedFile.path;
        controllers[id]?.text = base64Image;
      });
    }
  }

  Map<String, dynamic> getControllersMap() {
    Map<String, dynamic> newMap = {};
    controllers.forEach((key, value) {
      newMap[key] = value.text;
    });
    return newMap;
  }

  void _returnControllersMapToParent() {
    Map<String, dynamic> newMap = getControllersMap();
    widget.returnDynamicPageResult(newMap);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + keyboardHeight,
        ),
        child: Column(
          children: [
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    List.generate(widget.questionsAnswers.length, (index) {
                  return buildFormField(widget.questionsAnswers[index], index);
                }),
              ),
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
              onPressed: () {
                setState(() {
                  print(controllers);
                  showErrors = true;
                });
                bool allFieldsFilled = true;
                for (var element in controllers.values) {
                  if (element.text == null || element.text.isEmpty) {
                    allFieldsFilled = false;
                    break;
                  }
                }
                if (allFieldsFilled) {
                  _returnControllersMapToParent();
                }
              },
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
    );
  }

  Widget buildFormField(QuestionsAnswersModel question, int index) {
    String id = question.id.toString();
    String label = question.question;
    String type = question.question_type;

    TextInputType keyboardType = TextInputType.text;
    List<TextInputFormatter>? formatters;

    if (type == 'date') {
      return buildDateFormField(id, label, index);
    } else if (type == 'phone') {
      keyboardType = TextInputType.phone;
      formatters = phoneMaskFormatter;
    } else if (type == 'select') {
      return buildDropdownFormField(id, label, question.answers, index);
    } else if (type == 'checkbox') {
      return buildCheckboxFormField(id, label, question.answers, index);
    } else if (type == 'photo') {
      return buildPhotoFormField(
          id, label, index, keyboardType, type, formatters);
    }

    return buildDefaultFormField(
      id,
      label,
      index,
      keyboardType,
      type,
      formatters,
    );
  }

  Widget buildDefaultFormField(
      String id,
      String label,
      int index,
      TextInputType keyboardType,
      String type,
      List<TextInputFormatter>? formatters) {
    return Card(
      color: Color.fromRGBO(203, 203, 203, 0.85),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, textAlign: TextAlign.left),
            Form(
              child: TextFormField(
                controller: controllers[id],
                keyboardType: keyboardType,
                inputFormatters: formatters,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: controllers[id]!.text.isEmpty
                      ? 'Insira uma resposta'
                      : '',
                ),
                onChanged: (value) => setState(() {
                  setState(() {
                    controllers[id]?.text = value;
                  });
                }),
              ),
            ),
            if (showErrors &&
                (controllers[id]?.text == null ||
                    controllers[id]!.text.isEmpty))
              const Text(
                'Campo obrigatório.',
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
      ),
    );
  }

  Widget buildPhotoFormField(
    String id,
    String label,
    int index,
    TextInputType keyboardType,
    String type,
    List<TextInputFormatter>? formatters,
  ) {
    bool isEmpty = controllers[id]?.text.isEmpty ?? true;
    return Card(
      color: const Color.fromRGBO(203, 203, 203, 0.85),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, textAlign: TextAlign.left),
            isEmpty
                ? Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showOptionsBottomSheet(id);
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: const Text(
                        'Selecionar Foto',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 16.0),
                      Center(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                base64Decode(
                                    controllers[id]!.text.split(',')[1]),
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -10,
                              right: -10,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _showOptionsBottomSheet(id);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            if (showErrors &&
                (controllers[id]?.text == null ||
                    controllers[id]!.text.isEmpty))
              const Text(
                'Campo obrigatório.',
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
      ),
    );
  }

  Widget buildDateFormField(String id, String label, int index) {
    return Card(
      color: Color.fromRGBO(203, 203, 203, 0.85),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, textAlign: TextAlign.left),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: keys[index],
              child: TextFormField(
                onTap: () async {
                  DateTime? initialDate;
                  String? dateText = controllers[id]?.text;
                  if (dateText != null && DateTime.tryParse(dateText) != null) {
                    initialDate = DateTime.parse(dateText);
                  } else {
                    initialDate = DateTime(DateTime.now().year - 18);
                  }
                  FocusScope.of(context).requestFocus(new FocusNode());

                  DateTime? date = DateTime(1900);
                  FocusScope.of(context).requestFocus(new FocusNode());
                  date = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(
                        (DateTime.now().year - 18),
                      ));
                  if (date != null) {
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(date);
                    controllers[id]?.text = formattedDate;
                  }
                },
                controller: controllers[id],
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText:
                      controllers[id]!.text.isEmpty ? 'Ex 03/05/2000' : '',
                ),
              ),
            ),
            if (showErrors &&
                (controllers[id]?.text == null ||
                    controllers[id]!.text.isEmpty))
              const Text(
                'Campo obrigatório.',
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
      ),
    );
  }

  Widget buildDropdownFormField(
      String id, String label, List<AnswersModel>? answers, int index) {
    return Card(
      color: Color.fromRGBO(203, 203, 203, 0.85),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, textAlign: TextAlign.left),
            DropdownButtonFormField(
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    controllers[id]?.text = value;
                  }
                });
              },
              items: answers?.map<DropdownMenuItem<String>>((answer) {
                return DropdownMenuItem<String>(
                  value: answer.id.toString(),
                  child: Text(answer.answer.toString()),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: controllers[id]?.text?.isEmpty ?? true
                    ? 'Insira uma resposta'
                    : '',
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
            if (showErrors &&
                (controllers[id]?.text == null ||
                    controllers[id]!.text.isEmpty))
              const Text(
                'Campo obrigatório.',
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
      ),
    );
  }

  Widget buildCheckboxFormField(
      String id, String label, List<AnswersModel>? answers, int index) {
    return Card(
      color: Color.fromRGBO(203, 203, 203, 0.85),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            SizedBox(height: 8.0),
            Column(
              children: answers!.map<Widget>((answer) {
                return Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: Theme.of(context).primaryColor,
                      shape: CircleBorder(),
                      value:
                          selectedOptions[id]?.contains(answer.id.toString()) ??
                              false,
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value) {
                            if (!selectedOptions.containsKey(id)) {
                              selectedOptions[id] = [];
                            }
                            selectedOptions[id]!.add(answer.id.toString());
                          } else {
                            selectedOptions[id]!.remove(answer.id.toString());
                          }
                          controllers[id]?.text =
                              selectedOptions[id].toString();
                          if (controllers[id]?.text == '[]') {
                            controllers[id]?.text = '';
                          }
                        });
                      },
                    ),
                    Text(answer.answer.toString()),
                  ],
                );
              }).toList(),
            ),
            if (showErrors &&
                (controllers[id]?.text == null ||
                    controllers[id]!.text.isEmpty))
              const Text(
                'Campo obrigatório.',
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
      ),
    );
  }

  void _showOptionsBottomSheet(String id) {
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
                  pick(ImageSource.gallery, id);
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
                  pick(ImageSource.camera, id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
