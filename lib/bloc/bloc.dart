import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

final dio = Dio();

void getHttp() async {
  final response = await dio.get('https://dart.dev');
  print(response);
}


class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

class FetchSchoolsCubit extends Cubit<List<String>> {
  FetchSchoolsCubit() : super([]);

  Future<void> fetchSchools(String country) async {
    emit([]); // Clear previous data
    try {
      final response = await Dio().get(
        'https://api.example.com/schools', // Replace with your API endpoint
        queryParameters: {'country': country},
      );

      if (response.statusCode == 200) {
        emit(List<String>.from(response.data['schools']));
      } else {
        emit([]); // Handle failed API response
      }
    } catch (e) {
      emit([]); // Handle errors
    }
  }
}