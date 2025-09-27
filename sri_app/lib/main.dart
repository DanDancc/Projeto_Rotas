import 'package:flutter/material.dart';
import 'pages/locais/locais_list.dart';
import 'repositories/local_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S.R.I - Sistema de Rotas Inteligentes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LocaisListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
  void testDatabase() async {
  try {
    final repository = LocalRepository();
    bool result = await repository.testDatabase();
    print('Database test result: $result');
  } catch (e) {
    print('Database test error: $e');
  }
}

void main() {
  // Teste o banco antes de iniciar o app
  testDatabase();
  
  runApp(const MyApp());
}
}
