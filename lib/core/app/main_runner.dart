import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kidburg_banquet/core/app/logger.dart';

/// Класс запуска приложения
mixin MainRunner {
  static void _amendFlutterError() {
    const log = Logger.logFlutterError;

    FlutterError.onError = log;
  }

  static T? _runZoned<T>(T Function() body) =>
      Logger.runLogging(() => runZonedGuarded(body, Logger.logZoneError));

  static void run({required Future<Widget> Function() appBuilder}) {
    _runZoned(
      () async {
        _amendFlutterError();
        runApp(await appBuilder.call());
      },
    );
  }
}
