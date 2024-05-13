import 'package:benrica/src/domain/models/company_model.dart';

class ServiceModel {
  late int id;
  late String service_name;
  late String service_value;
  late String? service_description;
  late String service_time;
  late int id_businesses;
  late dynamic deleted_at;
  late String created_at;
  late dynamic updated_at;
  late CompanyModel? business;
  late String? status;
  late String? error;
  late Map<String, dynamic>? errors;
  late String? message;

  ServiceModel({
    required this.id,
    required this.service_name,
    required this.service_value,
    required this.service_description,
    required this.service_time,
    required this.id_businesses,
    required this.deleted_at,
    required this.created_at,
    required this.updated_at,
    this.business,
    this.status,
    this.error,
    this.errors,
    this.message,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      service_name: json['service_name'],
      service_value: json['service_value'],
      service_description: json['service_description'],
      service_time: json['service_time'] ?? '',
      id_businesses: json['id_businesses'] ?? 0,
      deleted_at: json['deleted_at'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      business: json['business'] != null
          ? CompanyModel.fromMap(json['business'])
          : null,
      status: json['status'],
      error: json['error'],
      errors: json['errors'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_name': service_name,
      'service_value': service_value,
      'service_description': service_description,
      'service_time': service_time,
      'id_businesses': id_businesses,
      'deleted_at': deleted_at,
      'created_at': created_at,
      'updated_at': updated_at,
      'business': business?.toJson(),
      'status': status,
      'error': error,
      'errors': errors,
      'message': message,
    };
  }
}
