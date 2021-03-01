// constants.dart - Tako Lansbergen 2020/02/23
//
// Constanten en helpers

class Constants {
  // TODO move to config?
  static const baseURL = "http://10.0.2.2:3000/api";
  static const defaultTimeout = 10;

  // API endpoints
  static final loginEndpoint = Constants.baseURL + '/login';
  static final qualificationsEndpoint = Constants.baseURL + '/qualifications';
}
