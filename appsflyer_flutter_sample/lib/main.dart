import 'package:flutter/material.dart';

import 'MyApp.dart';
import 'screens/start.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var result = await MyApp.init();
  print(result);
  runApp(Start(result));
}
