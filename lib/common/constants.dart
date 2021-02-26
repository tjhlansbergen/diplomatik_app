// constants.dart - Tako Lansbergen 2020/02/23
//
// Constanten en helpers

class Constants {
  // TODO move to config?
  static const baseURL = "10.0.2.2:3000";

  static const defaultTimeout = 10;

  // API endpoints
  static final loginEndpoint = Uri.http(Constants.baseURL, 'api/login');
  static final qualificationsEndpoint =
      Uri.http(Constants.baseURL, 'api/qualifications');
}
