import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class IApiGoogleSheet {
  static String url = dotenv.env['GOOGLE_API_URL'] ?? '';

  Future<String> get({String? languageSheet = 'en'});
}
