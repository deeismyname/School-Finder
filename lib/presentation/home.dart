import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/fetch_schools_cubit.dart';
import 'package:untitled/presentation/home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchSchoolsCubit(),
      child: const HomeView(), // Make sure HomeView is wrapped by this provider
    );
  }
}
