import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionApp {
  Future<void> requestPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;
    if (Platform.isAndroid) {
      final statusManageExternalStorage =
          await Permission.manageExternalStorage.status;
      final statusStorage = await Permission.storage.status;
      if (sdkInt <= 29) {
        if (statusStorage.isDenied) {
          print(statusStorage);
          if (await Permission.storage.request().isGranted) {
          } else {
            openAppSettings();
          }
        }
      } else {
        if (statusManageExternalStorage.isDenied) {
          if (await Permission.manageExternalStorage.request().isGranted) {}
        }
      }
    }
  }
}
