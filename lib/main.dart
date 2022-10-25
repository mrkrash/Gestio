import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gestio/db/DatabaseHelper.dart';
import 'package:gestio/page/Home.dart';

Future<void> main() async {
  await initApp();
  runApp(const MyApp());
}

//late LogMessageRepository _logMessageRepository;

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.init();
  //_logMessageRepository = LogMessageRepository(DatabaseHelper.instance.database!);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Gestio',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('it', '')
        ],
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: HomePage());
  }
}
