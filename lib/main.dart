import 'package:flutter/material.dart';

import 'app/app_widget.dart';
import 'app/core/helpers/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.initialize();

  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppWidget();
  }
}
