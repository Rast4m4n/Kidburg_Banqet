import 'package:permission_handler/permission_handler.dart';

class PermissionApp {
  Future<void> requestPermission() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
      print(status);
    } else {
      print("${status}");
    }
  }
}
