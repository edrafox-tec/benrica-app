// ignore: non_constant_identifier_names
class UserResponseInterface {
  final int id;
  final int id_businesses;
  final String user_name;
  final String email;
  final String phone_number;
  final int access_level;
  final dynamic reset_pass;
  final dynamic deleted_at;
  final dynamic created_at;
  final dynamic updated_at;
  final String? status;
  final String? error;
  final Map<String, dynamic>? errors;
  final String? message;
  final String? photo;
  final String? facebook;
  final String? instagram;
  final String? tiktok;
  final String? information;

  UserResponseInterface({
    required this.id,
    required this.id_businesses,
    required this.user_name,
    required this.email,
    required this.phone_number,
    required this.access_level,
    required this.reset_pass,
    required this.deleted_at,
    required this.created_at,
    required this.updated_at,
    required this.status,
    required this.error,
    required this.errors,
    required this.message,
    this.photo,
    this.facebook,
    this.instagram,
    this.tiktok,
    this.information,
  });

  UserResponseInterface.empty()
      : id = 0,
        id_businesses = 0,
        user_name = '',
        email = '',
        phone_number = '',
        access_level = 0,
        reset_pass = null,
        deleted_at = null,
        created_at = null,
        updated_at = null,
        status = null,
        error = null,
        errors = null,
        message = null,
        photo = null,
        facebook = null,
        instagram = null,
        tiktok = null,
        information = null;

  factory UserResponseInterface.fromMap(Map<String, dynamic> map) {
    return UserResponseInterface(
      id: map['id'],
      id_businesses: map['id_businesses'],
      user_name: map['user_name'],
      email: map['email'],
      phone_number: map['phone_number'],
      access_level: map['access_level'],
      reset_pass: map['reset_pass'],
      deleted_at: map['deleted_at'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      status: map['status'],
      error: map['error'],
      errors: map['errors'],
      message: map['message'],
      photo: map['photo'],
      facebook: map['facebook'],
      instagram: map['instagram'],
      tiktok: map['tiktok'],
      information: map['information'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_businesses': id_businesses,
      'user_name': user_name,
      'email': email,
      'phone_number': phone_number,
      'access_level': access_level,
      'reset_pass': reset_pass,
      'deleted_at': deleted_at,
      'created_at': created_at,
      'updated_at': updated_at,
      'status': status,
      'error': error,
      'errors': errors,
      'message': message,
      'photo': photo,
      'facebook': facebook,
      'instagram': instagram,
      'tiktok': tiktok,
      'information': information,
    };
  }
}
