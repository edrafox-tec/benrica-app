class UserCreateModel {
  final String user_name;
  final String email;
  final String phone_number;
  final int? id_businesses;
  final String password;
  final int? access_level;
  final List<AnswersCreateModel>? all_answers;

  UserCreateModel({
    required this.user_name,
    required this.email,
    required this.phone_number,
    required this.id_businesses,
    required this.password,
    required this.access_level,
    required this.all_answers,
  });

  factory UserCreateModel.fromMap(Map<String, dynamic> map) {
    return UserCreateModel(
      user_name: map['user_name'],
      email: map['email'],
      phone_number: map['phone_number'],
      password: map['password'],
      id_businesses: map['id_businesses'],
      access_level: map['access_level'],
      all_answers: (map['all_answers'] as List<dynamic>).map((answer) {
        return AnswersCreateModel.fromMap(answer);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'user_name': user_name,
      'email': email,
      'phone_number': phone_number,
      'password': password,
      'id_businesses': id_businesses,
      'access_level': access_level,
    };

    if (all_answers != null && all_answers!.isNotEmpty) {
      Map<String, dynamic> answersMap = {};
      for (int i = 0; i < all_answers!.length; i++) {
        answersMap['all_answers[$i][question_id]'] =
            all_answers![i].question_id;
        answersMap['all_answers[$i][answer]'] = all_answers![i].answer;
        answersMap['all_answers[$i][type]'] = all_answers![i].type;
      }
      json.addAll(answersMap);
    }

    return json;
  }

  @override
  String toString() {
    return 'UserCreateModel: {'
        ' user_name: $user_name,'
        ' email: $email,'
        ' phone_number: $phone_number,'
        ' id_businesses: $id_businesses,'
        ' password: $password,'
        ' access_level: $access_level,'
        ' all_answers: ${all_answers.toString()}'
        '}';
  }
}

class AnswersCreateModel {
  final String question_id;
  final dynamic answer;
  final String type;

  AnswersCreateModel({
    required this.question_id,
    required this.answer,
    required this.type,
  });

  @override
  String toString() {
    return 'question_id: $question_id, answer: $answer, type: $type';
  }

  factory AnswersCreateModel.fromMap(Map<String, dynamic> map) {
    return AnswersCreateModel(
      question_id: map['question_id'],
      answer: map['answer'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': question_id,
      'answer': answer,
      'type': type,
    };
  }
}

class UserCreateResponseModel {
  final String? message;
  // final UserResponseInterface? user;
  final String? status;
  final String? error;
  final Map<String, dynamic>? errors;

  UserCreateResponseModel({
    required this.message,
    // required this.user,
    required this.status,
    required this.error,
    required this.errors,
  });

  factory UserCreateResponseModel.fromMap(Map<String, dynamic> map) {
    return UserCreateResponseModel(
      message: map['message'],
      // user: UserResponseInterface.fromMap(map['user']),
      status: map['status'],
      error: map['error'],
      errors: map['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      // 'user': user?.toJson(),
      'status': status,
      'error': error,
      'errors': errors,
    };
  }

  @override
  String toString() {
    return 'UserCreateResponseModel { message: $message,  status: $status, error: $error, errors: $errors }';
  }
}
