import 'package:intl/intl.dart';

enum EstablishmentsEnum {
  riviera,
  cdm;

  const EstablishmentsEnum();

  String get localizedName {
    return Intl.message(
      _getDefaultName(),
      name: name,
    );
  }

  String _getDefaultName() {
    switch (this) {
      case EstablishmentsEnum.cdm:
        return 'CDM';
      case EstablishmentsEnum.riviera:
        return 'Riviera';
    }
  }
}
