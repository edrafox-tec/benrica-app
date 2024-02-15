
export class ApiUrl {

  public static URL_BASE: string = 'https://benrica-back.fly.dev'
  public static URL_IMAGE: string = 'https://edralivery-images.s3.amazonaws.com/criativoImg/'
  public static URL_VIDEO: string = 'https://edralivery-images.s3.amazonaws.com/'
  public static URL_FILE: string = 'https://edralivery-images.s3.amazonaws.com/criativoArquive/'

  // LOGIN
  public static LOGIN: string = this.URL_BASE + '/api/login';

  // USERS
  public static ADD_USER: string = this.URL_BASE + '/api/add/user';
  public static SAVE_USER_ANSWERS: string = this.URL_BASE + '/api/add/userreponse';
  public static UPDATE_USER: string = this.URL_BASE + '/api/update/user/:id';
  public static UPDATE_PASSWORD: string = this.URL_BASE + '/api/update/password/:id';
  public static GET_USERS: string = this.URL_BASE + '/api/show/user';
  public static GET_USER_ID: string = this.URL_BASE + '/api/store/user/:id';
  public static DELETE_USER: string = this.URL_BASE + '/api/delete/user/:id';

  // COLLABORATORS
  public static ADD_COLLABORATOR: string = this.URL_BASE + '/api/add/employee';
  public static UPDATE_COLLABORATOR: string = this.URL_BASE + '/api/update/employee/:id';
  public static GET_COLLABORATORS: string = this.URL_BASE + '/api/show/employee';
  public static GET_COLLABORATOR_ID: string = this.URL_BASE + '/api/store/employee/:id';
  public static DELETE_COLLABORATOR: string = this.URL_BASE + '/api/delete/employee/:id';

  // COMPANY
  public static ADD_COMPANY: string = this.URL_BASE + '/api/add/businesses';
  public static UPDATE_COMPANY: string = this.URL_BASE + '/api/update/businesses/:id';
  public static GET_COMPANIES: string = this.URL_BASE + '/api/show/businesses';
  public static GET_COMPANY_ID: string = this.URL_BASE + '/api/store/businesses/:id';
  public static DELETE_COMPANY: string = this.URL_BASE + '/api/delete/businesses/:id';

  // QUESTIONS
  public static ADD_QUESTION: string = this.URL_BASE + '/api/add/questions';
  public static UPDATE_QUESTION: string = this.URL_BASE + '/api/update/questions/:id';
  public static GET_QUESTIONS: string = this.URL_BASE + '/api/show/questions';
  public static GET_QUESTION_ID: string = this.URL_BASE + '/api/store/questions/:id';
  public static DELETE_QUESTION: string = this.URL_BASE + '/api/delete/questions/:id';
  public static GET_QUESTIONS_AND_ANSWERS: string = this.URL_BASE + '/api/list/questionswhitanswers';

  // ANSWERS
  public static ADD_ANSWER: string = this.URL_BASE + '/api/add/answers';
  public static UPDATE_ANSWER: string = this.URL_BASE + '/api/update/answers/:id';
  public static GET_ANSWERS: string = this.URL_BASE + '/api/show/answers';
  public static GET_ANSWER_ID: string = this.URL_BASE + '/api/store/answers/:id';
  public static DELETE_ANSWER: string = this.URL_BASE + '/api/delete/answers/:id';

  // SERVICE
  public static ADD_SERVICE: string = this.URL_BASE + '/api/add/services';
  public static UPDATE_SERVICE: string = this.URL_BASE + '/api/update/services/:id';
  public static GET_SERVICES: string = this.URL_BASE + '/api/show/services';
  public static GET_SERVICE_ID: string = this.URL_BASE + '/api/store/services/:id';
  public static DELETE_SERVICE: string = this.URL_BASE + '/api/delete/services/:id';

  // SCHEDULING
  public static ADD_SCHEDULING: string = this.URL_BASE + '/api/add/scheduling';
  public static UPDATE_SCHEDULING: string = this.URL_BASE + '/api/update/scheduling/:id';
  public static GET_SCHEDULING: string = this.URL_BASE + '/api/show/scheduling';
  public static GET_SCHEDULING_ID: string = this.URL_BASE + '/api/store/scheduling/:id';
  public static DELETE_SCHEDULING: string = this.URL_BASE + '/api/delete/scheduling/:id';

  // PASSWORD RECOVERY
  public static SEND_EMAIL_CODE: string = this.URL_BASE + '/api/password/reset';
  public static RECOVERY_PASSWORD: string = this.URL_BASE + '/api/reset/password';
};
