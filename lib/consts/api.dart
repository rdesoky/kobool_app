import 'package:flutter_dotenv/flutter_dotenv.dart';

class API {
  static String get apiOrigin =>
      dotenv.env['API_ORIGIN'] ?? 'http://dev.kobool.com';
  static String get query => "$apiOrigin/cgi-bin/query.pl";
  static String get user => "$apiOrigin/cgi-bin/member.pl";
  static String get login => "$apiOrigin/cgi-bin/login.pl";
  static String get logout => "$apiOrigin/cgi-bin/logout.pl";
  static String get searchAnswers => "$apiOrigin/cgi-bin/qa/search_answers.pl";
}
