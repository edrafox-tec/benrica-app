class QuestionsAnswersModel {
  final int id;
  final String question;
  final String question_type;
  final List<AnswersModel>? answers;
  final int id_businesses;
  final int position;
  final String? deleted_at;
  final String created_at;
  final String? updated_at;
  final String? status;
  final String? error;
  final Map<String, dynamic>? errors;
  final String? message;

  QuestionsAnswersModel({
    required this.id,
    required this.question,
    required this.question_type,
    required this.answers,
    required this.id_businesses,
    required this.position,
    required this.deleted_at,
    required this.created_at,
    required this.updated_at,
    required this.status,
    required this.error,
    required this.errors,
    required this.message,
  });

  factory QuestionsAnswersModel.fromMap(Map<String, dynamic> map) {
    return QuestionsAnswersModel(
      id: map['id'],
      question: map['question'],
      question_type: map['question_type'],
      id_businesses: map['id_businesses'],
      position: map['position'],
      deleted_at: map['deleted_at'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      status: map['status'],
      error: map['error'],
      errors: map['errors'],
      message: map['message'],
      answers: (map['answers'] as List<dynamic>?)
              ?.map((answerMap) =>
                  AnswersModel.fromMap(answerMap as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AnswersModel {
  final int id;
  final String answer;
  final int id_question;
  final String? deleted_at;
  final String created_at;
  final String? updated_at;
  final String? status;
  final String? error;
  final Map<String, dynamic>? errors;
  final String? message;

  AnswersModel({
    required this.id,
    required this.answer,
    required this.id_question,
    required this.deleted_at,
    required this.created_at,
    required this.updated_at,
    required this.status,
    required this.error,
    required this.errors,
    required this.message,
  });

  factory AnswersModel.fromMap(Map<String, dynamic> map) {
    return AnswersModel(
      id: map['id'],
      answer: map['answer'],
      id_question: map['id_question'],
      deleted_at: map['deleted_at'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      status: map['status'],
      error: map['error'],
      errors: map['errors'],
      message: map['message'],
    );
  }
}
