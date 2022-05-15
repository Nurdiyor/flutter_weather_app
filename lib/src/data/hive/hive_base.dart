import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';


class HiveBase {
  late Box box;
  late Box postBox;
  late Box categoryBox;
  late Box tagBox;

  Future<void> init() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    Hive.init('${dir.path}/weather.hv');
    box = await Hive.openBox('weatherBox');
  }
}
