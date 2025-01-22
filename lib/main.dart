import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/bloc/fetch_schools_cubit.dart';
import 'package:untitled/presentation/home_page.dart';

void main() => runApp(SchoolFinder());

class SchoolFinder extends StatelessWidget {
  SchoolFinder({super.key});

  // GoRouter configuration for managing routes
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/', // Root path
        builder: (context, state) => BlocProvider(
          create: (_) => FetchSchoolsCubit(), // BlocProvider to inject FetchSchoolsCubit
          child: const HomeView(), // HomeView is the main screen
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router, // Set GoRouter as the routing mechanism
      theme: ThemeData(
        primaryColor: const Color(0xFF344443),
        scaffoldBackgroundColor: const Color(0xFFF7F5F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF344443),
          primary: const Color(0xFF344443),
          secondary: const Color(0xFFD6CEC0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF344443),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF29292A)),
          bodyMedium: TextStyle(color: Color(0xFF29292A)),
        ),
      ),
    );
  }
}
