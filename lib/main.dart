import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/app.dart';
import 'package:ip_manager/provider/user_session.dart';

import 'core/database/prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final savedRole = await Prefs().getUserRole;

  final sessionNotifier = UserSessionNotifier();
  if (savedRole.isNotEmpty) {
    sessionNotifier.updateSession(role: savedRole, isLogin: true);
  }
  runApp(
    ProviderScope(
      overrides: [
        userSessionProvider.overrideWith((ref) => sessionNotifier),
      ],
      child: const MyApp(),
    ),
  );
}
