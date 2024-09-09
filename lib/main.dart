import 'package:chat_app/core/navigation/router_config/router_config.dart';
import 'package:chat_app/core/theme/dark_mode.dart';
import 'package:chat_app/core/theme/light_mode.dart';
import 'package:chat_app/core/theme/theme_provider.dart';
import 'package:chat_app/feature/signup/presentation/pages/signup_page.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final ThemeData themeData =
        ref.read(themeModeProvider.notifier).getThemeData(themeMode);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: MyRouterConfig.router,
      theme: themeData,
    );
  }
}
