import 'package:http/http.dart' as http;
import 'package:kidburg_banquet/api/i_api_google_sheet.dart';

class GoogleSheetApi implements IApiGoogleSheet {
  @override
  Future<String> get({String? languageSheet = 'ru'}) async {
    final response =
        await http.get(Uri.parse("${IApiGoogleSheet.url}$languageSheet"));
    switch (response.statusCode) {
      case 200:
        try {
          print(response.body);
          return response.body;
        } catch (e) {
          throw FormatException('Ошибка форматирования данных: $e');
        }
      case 404:
        throw Exception('Данные не найдены (404)');
      case 500:
        throw Exception('Ошибка стороны сервера (500)');
      default:
        throw Exception('Ошибка загрузки данных: ${response.statusCode}');
    }
  }
}
