import 'dart:math';

import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  String _formattedPhone = '';

  static const List<String> _russianPrefixes = ['7', '8', '9'];

  PhoneInputFormatter(String? initialString) {
    if (initialString != null) {
      formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: initialString),
      );
    }
  }

  /// Форматирование введенного текста в зависимости от того, является ли он российским или американским номером
  String _formattingPhone(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isEmpty) return '';

    if (_russianPrefixes.contains(digitsOnly[0])) {
      return _formatRussianPhone(digitsOnly);
    }

    return _formattingUSPhone(digitsOnly);
  }

  /// Форматирование российского номера
  String _formatRussianPhone(String text) {
    if (text[0] == '9') {
      text = '7$text';
    }

    final firstNumberPhone = (text[0] == '8') ? '8' : '+7';
    final partsOfNumber = <String>[firstNumberPhone];

    // +7 (999
    if (text.length > 1) {
      partsOfNumber.add('(${_getSubstringOrEmpty(text, 1, 4)}');
    }

    // +7 (999) 999
    if (text.length >= 5) {
      partsOfNumber[1] += ')';
      partsOfNumber.add(_getSubstringOrEmpty(text, 4, 7));
    }
    // +7 (999) 999-99
    if (text.length >= 8) {
      partsOfNumber.add(_getSubstringOrEmpty(text, 7, 9));
      partsOfNumber[2] += '-';
    }
    // +7 (999) 999-99-99
    if (text.length >= 10) {
      partsOfNumber.add(_getSubstringOrEmpty(text, 9, 11));
      partsOfNumber[3] += '-';
    }

    // соединяем все части номера в одну строку и добавляем пробелы после скобок
    return partsOfNumber.join('').replaceAll(')', ') ').replaceAll('(', ' (');
  }

  /// Форматирование американского номера
  String _formattingUSPhone(String text) {
    final partsOfNumber = <String>['+1'];
    if (text.length > 1) {
      partsOfNumber.add("(${_getSubstringOrEmpty(text, 1, 4)}");
    }
    if (text.length >= 5) {
      partsOfNumber[1] += ')';
      partsOfNumber.add(_getSubstringOrEmpty(text, 4, 7));
    }
    if (text.length >= 8) {
      partsOfNumber[2] += '-';
      partsOfNumber.add(_getSubstringOrEmpty(text, 7, 11));
    }
    // соединяем все части номера в одну строку и добавляем пробелы после скобок
    return partsOfNumber.join('').replaceAll(')', ') ').replaceAll('(', ' (');
  }

  /// Безопасно извлекает подстроку из строки,
  /// если индекс выходит за границы строки, то возвращает пустую строку
  String _getSubstringOrEmpty(String text, int start, int end) {
    if (start >= text.length) return '';
    return text.substring(start, min(end, text.length));
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    int selectionStart = oldValue.selection.end;

    // Стирание текста в любой позиции без потери курсора
    if (selectionStart != _formattedPhone.length) {
      _formattedPhone = _formattingPhone(text);
      return TextEditingValue(
        text: _formattedPhone,
        selection: TextSelection(
          baseOffset: newValue.selection.baseOffset,
          extentOffset: newValue.selection.extentOffset,
        ),
      );
    }

    _formattedPhone = _formattingPhone(text);

    return TextEditingValue(
      text: _formattedPhone,
      selection: TextSelection(
        baseOffset: _formattedPhone.length,
        extentOffset: _formattedPhone.length,
      ),
    );
  }
}
