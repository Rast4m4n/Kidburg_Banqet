import 'package:intl/intl.dart';

enum LanguageEnum {
  english,
  russian;

  const LanguageEnum();

  String get localizedName {
    return Intl.message(
      _getDefaultName(),
      name: name,
    );
  }

  String _getDefaultName() {
    switch (this) {
      case LanguageEnum.russian:
        return 'Russian';
      case LanguageEnum.english:
        return 'English';
    }
  }
}
