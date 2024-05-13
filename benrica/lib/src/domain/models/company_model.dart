class CompanyModel {
  final int id;
  final int exclusive;
  final String business_name;
  final String email;
  final String phone;
  final String cnpj;
  final String password;
  final String? reset_pass;
  final String? initial_time;
  final String? final_time;
  final String? logo_img;
  final String? facebook;
  final String? instagram;
  final String? tiktok;
  final String? business_information;
  final String? deleted_at;
  final String created_at;
  final String updated_at;
  final String? status;
  final String? error;
  final Map<String, dynamic>? errors;
  final String? message;

  CompanyModel({
    required this.id,
    required this.exclusive,
    required this.business_name,
    required this.email,
    required this.phone,
    required this.cnpj,
    required this.password,
    required this.reset_pass,
    required this.initial_time,
    required this.final_time,
    required this.logo_img,
    required this.facebook,
    required this.instagram,
    required this.tiktok,
    required this.business_information,
    required this.deleted_at,
    required this.created_at,
    required this.updated_at,
    required this.status,
    required this.error,
    required this.errors,
    required this.message,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['id'],
      exclusive: map['exclusive'],
      business_name: map['business_name'],
      email: map['email'],
      phone: map['phone'],
      cnpj: map['cnpj'],
      password: map['password'],
      reset_pass: map['reset_pass'],
      initial_time: map['initial_time'],
      final_time: map['final_time'],
      logo_img: map['logo_img'],
      facebook: map['facebook'],
      instagram: map['instagram'],
      tiktok: map['tiktok'],
      business_information: map['business_information'],
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
      'exclusive': exclusive,
      'business_name': business_name,
      'email': email,
      'phone': phone,
      'cnpj': cnpj,
      'password': password,
      'reset_pass': reset_pass,
      'initial_time': initial_time,
      'final_time': final_time,
      'logo_img': logo_img,
      'facebook': facebook,
      'instagram': instagram,
      'tiktok': tiktok,
      'business_information': business_information,
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
