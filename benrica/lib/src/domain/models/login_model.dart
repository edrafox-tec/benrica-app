// ignore_for_file: non_constant_identifier_names

import 'package:benrica/src/domain/models/company_model.dart';
import 'package:benrica/src/domain/models/user_model.dart';

class LoginModel {
  final String? access_token;
  final String? token_type;
  final dynamic expires_in;
  final UserResponseInterface? user;
  final CompanyModel? businesses;
  final String? status;
  final String? error;
  final Map<String, dynamic>? errors;
  final String? message;

  LoginModel({
    required this.access_token,
    required this.token_type,
    required this.expires_in,
    required this.user,
    required this.businesses,
    required this.status,
    required this.error,
    required this.errors,
    required this.message,
  });

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      access_token: map['access_token'],
      token_type: map['token_type'],
      expires_in: map['expires_in'],
      user: UserResponseInterface.fromMap(map['user']),
      businesses: CompanyModel.fromMap(map['businesses']),
      status: map['status'],
      error: map['error'],
      errors: map['errors'],
      message: map['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': access_token,
      'token_type': token_type,
      'expires_in': expires_in,
      'user': user?.toJson(),
      'businesses': businesses?.toJson(),
      'status': status,
      'error': error,
      'errors': errors,
      'message': message,
    };
  }
}
