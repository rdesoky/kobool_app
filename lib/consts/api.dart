// import 'package:flutter_dotenv/flutter_dotenv.dart';

class API {
  static String fastApiOrigin =
      'http://localhost:8000'; // Python FastAPI server

  static String get apiOrigin => const String.fromEnvironment(
    'API_URL',
    // defaultValue: 'http://dev.kobool.com/cgi-bin',
    defaultValue: 'http://localhost:5000', // Plack HTTP::SERVER::PSGI
    // defaultValue: 'http://localhost:8000', // Python FastAPI server
  );

  // from Python FastAPI server
  static String get query => "$fastApiOrigin/query.pl";
  static String get searchAnswers => "$fastApiOrigin/qa/search_answers.pl";
  static String get questionList => "$fastApiOrigin/qa/question_list.pl";
  static String get login => "$fastApiOrigin/login.pl";

  // from Plack HTTP::SERVER::PSGI
  static String get user => "$apiOrigin/member.pl";
  static String get logout => "$apiOrigin/logout.pl";
  static String get pic => "$apiOrigin/kpic.pl";
}
