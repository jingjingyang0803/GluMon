import 'package:flutter/material.dart';
import 'package:glu_mon/providers/glucose_provider.dart';
import 'package:glu_mon/screens/base_screen.dart';
import 'package:provider/provider.dart';

void main() {
  (
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlucoseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: HomePage(),
      home: BaseScreen(),
    );
  }
}
