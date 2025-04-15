abstract class IApiGoogleSheet {
  static const String url =
      'https://script.google.com/macros/s/AKfycbxXJeSKKUNFpWqjZcRRJDVKUEZI1xiMwUfS0ORC8tGNDykytx3WTKY5jzfN2KkHEULvuA/exec?sheet=';

  Future<String> get({String? languageSheet = 'en'});
}
