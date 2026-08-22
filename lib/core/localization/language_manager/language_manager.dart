import 'package:bnan_app/core/cache/cache_data.dart';
import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/cache/cache_key.dart';
import 'package:bnan_app/core/localization/language_manager/language_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageState(const Locale('ar'))) {
    getSavedLanguage();
  }

  static LanguageCubit get(context) => BlocProvider.of(context);

  void getSavedLanguage() {
    final langCode = CacheHelper.getData(key: CacheKey.language);
    if (langCode != null && langCode != state.locale.languageCode) {
      emit(LanguageState(Locale(langCode)));
    }
  }

  Future<void> toggleLanguage() async {
    final newLang = state.locale.languageCode == 'en' ? 'ar' : 'en';
    await CacheHelper.saveData(key: CacheKey.language, value: newLang);
    CacheData.setLanguage(newLang);
    emit(LanguageState(Locale(newLang)));
  }
}
