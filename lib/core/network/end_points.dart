
abstract class EndPoints {
  static String get baseUrl => 'http://bnan.0xcode7.xyz/api/v1/';

  // Base paths
  static  String users = '${baseUrl}users/';

  // Auth / Password
  static  String register = '${users}register';
  static  String login = '${users}login';
  static  String forgotPassword = '${users}forgotPassword';
  static  String verifyResetCode = '${users}verifyResetCode';
  static  String resetPassword = '${users}resetPassword';
  static  String updatePassword = '${users}updatePassword';


}