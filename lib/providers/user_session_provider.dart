import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

class UserSession {
  final String? id;
  final String? sessionId;
  final String? loginId;
  final int? gender;
  final DateTime? lastLogin;
  final int? loginCount;
  final int? sinceLastLogin;
  final int? questions;
  final int? visitors;
  final bool? activated;
  final bool? blackList;
  final bool? inactiveByHk;

  bool isLoggedIn() {
    return sessionId != null && sessionId!.isNotEmpty;
  }

  UserSession({
    this.sessionId,
    this.gender,
    this.lastLogin,
    this.loginCount,
    this.questions,
    this.visitors,
    this.activated,
    this.loginId,
    this.blackList,
    this.sinceLastLogin,
    this.inactiveByHk,
    this.id,
  });

  factory UserSession.fromJson(String json) {
    final data = jsonDecode(json);
    return UserSession(
      sessionId: data['session_id'],
      gender: data['gender'],
      lastLogin: data['last_login'] != null && data['last_login'].isNotEmpty
          ? DateTime.parse(data['last_login'])
          : null,
      loginCount: data['login_count'],
      questions: data['questions'],
      visitors: data['visitors'],
      activated: data['activated'],
      loginId: data['login_id'],
      blackList: data['black_list'],
      sinceLastLogin: data['since_last_login'],
      inactiveByHk: data['inactive_by_hk'],
      id: data['id'],
    );
  }

  factory UserSession.fromXml(XmlElement element) {
    final sessionId = element.getAttribute('sid');
    final id = element.getAttribute("id");
    final loginId = element.getAttribute("login_id");
    final gender = element.getAttribute('gender');
    final activated = element.getAttribute("activated");
    final lastLogin = element.getAttribute("last_login");
    final loginCount = element.getAttribute("login_count");
    final sinceLastLogin = element.getAttribute("since_last_login");
    final questions = element.getAttribute("questions");
    final visitors = element.getAttribute("visitors");
    final blackList = element.getAttribute("black_list");
    final inactiveByHk = element.getAttribute("inactive_by_hk");

    final json = jsonEncode({
      'id': id,
      'login_id': loginId,
      'session_id': sessionId,
      'gender': gender != null && gender.isNotEmpty ? int.parse(gender) : null,
      'last_login': lastLogin != null && lastLogin.isNotEmpty
          ? lastLogin
          : null,
      'login_count': loginCount != null && loginCount.isNotEmpty
          ? int.parse(loginCount)
          : null,
      'questions': questions != null && questions.isNotEmpty
          ? int.parse(questions)
          : null,
      'visitors': visitors != null && visitors.isNotEmpty
          ? int.parse(visitors)
          : null,
      'activated': activated != null && activated.isNotEmpty
          ? activated == "1"
          : null,
      'black_list': blackList != null && blackList.isNotEmpty
          ? blackList == "1"
          : null,
      'since_last_login': sinceLastLogin != null && sinceLastLogin.isNotEmpty
          ? int.parse(sinceLastLogin)
          : null,
      'inactive_by_hk': inactiveByHk != null && inactiveByHk.isNotEmpty
          ? inactiveByHk == "1"
          : null,
    });

    return UserSession.fromJson(json);
  }

  String toJson() => jsonEncode({
    'id': id,
    'login_id': loginId,
    'session_id': sessionId,
    'gender': gender,
    'last_login': lastLogin?.toIso8601String(),
    'login_count': loginCount,
    'questions': questions,
    'visitors': visitors,
    'activated': activated,
    'black_list': blackList,
    'since_last_login': sinceLastLogin,
    'inactive_by_hk': inactiveByHk,
  });
}

class UserSessionNotifier extends Notifier<UserSession> {
  late final SharedPreferences _prefs;

  @override
  UserSession build() {
    _prefs = ref.read(
      sharedPreferencesProvider,
    ); // using watch will rebuild the provider state when the shared preferences change

    final json = _prefs.getString('user_session');

    if (json != null) {
      return UserSession.fromJson(json);
    }

    // ref.onDispose(() {
    //   _prefs.setString('user_session', state.toJson());
    // });

    return UserSession(); // initial empty user session
  }

  void setUserSession(UserSession session) {
    state = session;
    _prefs.setString('user_session', session.toJson());
  }

  void clearUserSession() {
    state = UserSession();
    _prefs.remove('user_session');
  }
}

final userSessionProvider = NotifierProvider<UserSessionNotifier, UserSession>(
  UserSessionNotifier.new,
);
