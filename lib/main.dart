import 'package:cbl/cbl.dart';
import 'package:flutter/material.dart';
import 'package:gestio/customer/CustomerRepository.dart';
import 'package:gestio/db/DatabaseHelper.dart';
import 'package:gestio/log/LogMessageRepository.dart';
import 'package:gestio/page/Home.dart';

Future<void> main() async {
  await initApp();
  runApp(const MyApp());
}

late LogMessageRepository _logMessageRepository;

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.init();
  _logMessageRepository = LogMessageRepository(DatabaseHelper.instance.database!);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Gestio',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: HomePage());
  }
}
