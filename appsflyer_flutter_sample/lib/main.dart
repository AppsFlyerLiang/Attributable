import 'package:flutter/material.dart';
import 'package:fluttersample/models/app_data.dart';
import 'app_config.dart';

import 'screens/my_app.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(await AppConfig.checkAgreement()));
}
