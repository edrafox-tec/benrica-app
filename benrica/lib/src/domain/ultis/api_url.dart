// ignore_for_file: constant_identifier_names

class ApiUrl {
  static const BASE_API = "https://benrica-back.fly.dev/";
  static const URL_IMAGE =
      'https://edra-app-images.s3.sa-east-1.amazonaws.com/benrica/';

  //LOGIN
  static const String LOGIN = "${BASE_API}api/login";

  //COMPANY
  static const String GET_COMPANIES = "${BASE_API}api/show/businesses";

  //SERVICES
  static const String GET_STORE_SERVICES = "${BASE_API}api/show/services/:id";

  //SCHEDULE
  static const String GET_STORE_SCHEDULE =
      "${BASE_API}api/show/all/scheduling/:id";
  static const String ADD_SCHEDULE = "${BASE_API}api/add/scheduling";

  //QUESTIONS AND ANSWERS
  static const String GET_QUESTIONS_ANSWERS =
      "${BASE_API}api/list/questionswhitanswers/:id";
  static const String ADD_QUESTIONS_ANSWERS = "${BASE_API}api/add/scheduling";

  //USER
  static const String CREATE_USER = "${BASE_API}api/add/user";
  static const String UPDATE_USER = "${BASE_API}api/update/user/:id";
}
