// import 'package:flutter_dotenv/flutter_dotenv.dart';

class API {
  static String get apiOrigin => const String.fromEnvironment(
    'API_URL',
    // defaultValue: 'http://dev.kobool.com/cgi-bin',
    defaultValue: 'http://localhost:5000', // Plack HTTP::SERVER::PSGI
  );

  static String get query => "$apiOrigin/query.pl";
  static String get user => "$apiOrigin/member.pl";
  static String get login => "$apiOrigin/login.pl";
  static String get logout => "$apiOrigin/logout.pl";
  static String get searchAnswers => "$apiOrigin/qa/search_answers.pl";
  static String get pic => "$apiOrigin/kpic.pl";
}
