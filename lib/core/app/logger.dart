import 'package:flutter/material.dart';
import 'package:l/l.dart'; // Библиотека для логирования
import 'package:stack_trace/stack_trace.dart'; // Для обработки стека вызовов

/// Расширение [LogLevel] для добавления эмодзи к уровням логирования.
extension on LogLevel {
  String get emoji => maybeWhen(
        shout: () => '❗️', // Критические ошибки
        error: () => '🚫', // Ошибки
        warning: () => '⚠️', // Предупреждения
        info: () => '💡', // Информационные сообщения
        debug: () => '🐞', // Отладочные сообщения
        orElse: () => '', // Значение по умолчанию
      );
}

/// Миксин для логирования, содержащий настройки и методы для вывода ошибок.
mixin Logger {
  /// Опции логирования, отключающие цветной вывод и задающие формат сообщений.
  static const _logOptions = LogOptions(
    printColors: false,
    messageFormatting: _formatLoggerMessage,
  );

  /// Форматирование сообщения для логирования.
  static String _formatLoggerMessage(LogMessage message) =>
      '${message.level.emoji} ${message.timestamp} | $message';

  /// Форматирование ошибки с указанием типа, сообщения и стека вызовов.
  static String _formatError(
    String type,
    String error,
    StackTrace? stackTrace,
  ) {
    final trace = stackTrace ?? StackTrace.current;

    final buffer = StringBuffer(type)
      ..write(' error: ')
      ..writeln(error)
      ..writeln('Stack trace:')
      ..write(Trace.from(trace).terse); // Упрощенный стек вызовов

    return buffer.toString();
  }

  /// Логирование ошибок верхнего уровня (например, пойманных в `runZoned`).
  static void logZoneError(
    Object? e,
    StackTrace s,
  ) {
    l.e(_formatError('Top-level', e.toString(), s), s);
  }

  /// Логирование ошибок, пойманных в системе Flutter.
  static void logFlutterError(
    FlutterErrorDetails details,
  ) {
    final stack = details.stack;
    l.e(_formatError('Flutter', details.exceptionAsString(), stack), stack);
  }

  /// Запуск кода в окружении логирования.
  ///
  /// Все ошибки и исключения, возникшие в `body`, будут обработаны логером `l`.
  static T runLogging<T>(T Function() body) => l.capture(body, _logOptions);
}
