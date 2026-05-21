import 'package:flutter/material.dart';

import 'app/app_widget.dart';
import 'app/core/helpers/database_helper.dart';
import 'app/core/services/sync_system_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.initialize();
  await SyncSystemInitializer.initialize();

  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppWidget();
  }
}
