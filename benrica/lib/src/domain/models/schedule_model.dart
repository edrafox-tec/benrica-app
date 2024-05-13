// ignore_for_file: non_constant_identifier_names

class ScheduleModel {
  final int id;
  final int id_user;
  final String scheduling_name_client;
  final String scheduling_date_time;
  final String scheduling_time_total;
  final String? scheduling_phone;
  final int id_service;
  final String? scheduling_advance_value;
  final int scheduling_status;
  final String? deleted_at;
  final String? created_at;
  final String? updated_at;
  final String? status;
  final String? error;
  final Map<String, dynamic>? errors;
  final String? message;

  ScheduleModel({
    required this.id,
    required this.id_user,
    required this.scheduling_name_client,
    required this.scheduling_date_time,
    required this.scheduling_time_total,
    required this.scheduling_phone,
    required this.id_service,
    required this.scheduling_advance_value,
    required this.scheduling_status,
    required this.deleted_at,
    required this.created_at,
    required this.updated_at,
    required this.status,
    required this.error,
    required this.errors,
    required this.message,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'],
      id_user: map['id_user'],
      scheduling_name_client: map['scheduling_name_client'],
      scheduling_date_time: map['scheduling_date_time'],
      scheduling_time_total: map['scheduling_time_total'],
      scheduling_phone: map['scheduling_phone'],
      id_service: map['id_service'],
      scheduling_advance_value: map['scheduling_advance_value'],
      scheduling_status: map['scheduling_status'],
      deleted_at: map['deleted_at'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      status: map['status'],
      error: map['error'],
      errors: map['errors'],
      message: map['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': id_user,
      'scheduling_name_client': scheduling_name_client,
      'scheduling_date_time': scheduling_date_time,
      'scheduling_time_total': scheduling_time_total,
      'scheduling_phone': scheduling_phone,
      'id_service': id_service,
      'scheduling_advance_value': scheduling_advance_value,
      'scheduling_status': scheduling_status,
      'deleted_at': deleted_at,
      'created_at': created_at,
      'updated_at': updated_at,
      'status': status,
      'error': error,
      'errors': errors,
      'message': message,
    };
  }
}
