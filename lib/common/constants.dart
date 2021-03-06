// constants.dart - Tako Lansbergen 2020/02/23
//
// Constanten en enums

class Constants {
  // API instellingen
  static const baseURL = "http://10.0.2.2:3000/api";
  static const defaultTimeout = 10;

  // API endpoints
  static final loginEndpoint = Constants.baseURL + '/login';
  static final qualificationsEndpoint = Constants.baseURL + '/qualifications';
  static final coursesEndpoint = Constants.baseURL + '/courses';
  static final studentsEndpoint = Constants.baseURL + '/students';
  static final usersEndpoint = Constants.baseURL + '/users';
}

enum SelectionContext { customer, course, student }
