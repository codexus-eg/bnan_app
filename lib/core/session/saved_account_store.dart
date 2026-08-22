import 'dart:convert';

import 'package:bnan_app/core/cache/secure_cache_helper.dart';
import 'package:bnan_app/core/cache/secure_cache_keys.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';

class SavedAccount {
  const SavedAccount({
    required this.userId,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.refreshToken,
    this.registrationMode,
    this.registrationModes = const [],
  });

  final String userId, name, role, email, phone, refreshToken;
  final RegistrationMode? registrationMode;
  final List<RegistrationMode> registrationModes;

  String get identifier => email.isNotEmpty ? email : phone;

  factory SavedAccount.fromJson(Map<String, dynamic> json) => SavedAccount(
    userId: _text(json['userId']),
    name: _text(json['name']),
    role: _text(json['role']),
    email: _text(json['email']),
    phone: _text(json['phone']),
    refreshToken: _text(json['refreshToken']),
    registrationMode: RegistrationMode.fromValue(json['registrationMode']),
    registrationModes: RegistrationMode.fromList(json['registrationModes']),
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'role': role,
    'email': email,
    'phone': phone,
    'refreshToken': refreshToken,
    'registrationMode': registrationMode?.name,
    'registrationModes': registrationModes.map((item) => item.name).toList(),
  };
}

abstract class SavedAccountStore {
  static Future<List<SavedAccount>> load() async {
    try {
      final raw = await SecureCacheHelper.getData(
        key: SecureCacheKeys.savedAccounts,
      );
      if (raw == null || raw.isEmpty) return const [];
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map((item) => SavedAccount.fromJson(Map<String, dynamic>.from(item)))
          .where((item) => item.userId.isNotEmpty)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  static Future<bool> hasAccounts() async => (await load()).isNotEmpty;

  static Future<void> upsert(SavedAccount account) async {
    if (account.userId.isEmpty || account.refreshToken.isEmpty) return;
    final accounts = [...await load()]
      ..removeWhere((item) => item.userId == account.userId)
      ..insert(0, account);
    await _save(accounts);
  }

  static Future<List<SavedAccount>> remove(String userId) async {
    final accounts = [...await load()]
      ..removeWhere((item) => item.userId == userId);
    await _save(accounts);
    return accounts;
  }

  static Future<void> _save(List<SavedAccount> accounts) =>
      SecureCacheHelper.saveData(
        key: SecureCacheKeys.savedAccounts,
        value: jsonEncode(accounts.map((item) => item.toJson()).toList()),
      );
}

String _text(Object? value) => value?.toString().trim() ?? '';
