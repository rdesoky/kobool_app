import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  //TODO: set expiry time for each value
  final String? id;
  // final String? mate_id; //mid

  final String? sessionId; //sid
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
    return id != null;
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

  factory UserSession.fromResponse(Response response) {
    final sessionId = response.headers.value('sid');
    final id = response.data['id'];
    final loginId = response.data['login_id'];
    final gender = response.data['gender'];
    final activated = response.data['activated'];
    final lastLogin = response.data['last_login'];
    final loginCount = response.data['login_count'];
    final sinceLastLogin = response.data['since_last_login'];
    final questions = response.data['questions'];
    final visitors = response.data['visitors'];
    final blackList = response.data['black_list'];
    final inactiveByHk = response.data['inactive_by_hk'];

    final json = jsonEncode({
      'id': id?.toString(),
      'login_id': loginId,
      'session_id': sessionId,
      'gender': gender,
      'last_login': lastLogin,
      'login_count': loginCount,
      'questions': questions,
      'visitors': visitors,
      'activated': activated == 1,
      'black_list': blackList == 1,
      'since_last_login': sinceLastLogin,
      'inactive_by_hk': inactiveByHk == 1,
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

  List<Cookie> toCookieList() {
    final myInfo = [
      'gender=$gender',
      if (activated != null) 'active=${activated! ? "1" : "0"}',
      'mate=undefined', // matched user id
      'mtid=undefined', // matched chat thread id
    ].join('&');

    return [
      'id=$id',
      'sid=$sessionId',
      'myinfo=${Uri.encodeComponent(myInfo)}',
      // 'sa=' + DateTime.now(),//set last activity timestamp
    ].map((e) => Cookie.fromSetCookieValue(e)).toList();
  }

  String toCookieString() {
    return toCookieList().map((e) => e.toString()).join('; ');
  }
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

  UserSession clearUserSession() {
    state = UserSession();
    _prefs.remove('user_session');
    return state;
  }
}

final userSessionProvider = NotifierProvider<UserSessionNotifier, UserSession>(
  UserSessionNotifier.new,
);
