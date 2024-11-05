import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_bloc/presentation/bloc/starter/starter_bloc.dart';
import 'package:gemini_bloc/presentation/pages/home_page.dart';
import 'package:gemini_bloc/presentation/pages/starter_page.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => StarterBloc(),
        child: StarterPage(),
      ),
      routes: {
        HomePage.id: (context) => HomePage(),
      },
    );
  }
}