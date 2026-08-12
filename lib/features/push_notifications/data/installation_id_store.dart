import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:uuid/uuid.dart';

class InstallationIdStore {
  InstallationIdStore({Uuid uuid = const Uuid()}) : _uuid = uuid;

  static const _key = 'push_installation_id';
  final Uuid _uuid;

  Future<String> getOrCreate() async {
    final saved = CacheHelper.getData(key: _key)?.toString().trim() ?? '';
    if (saved.isNotEmpty) return saved;
    final value = _uuid.v4();
    await CacheHelper.saveData(key: _key, value: value);
    return value;
  }
}
