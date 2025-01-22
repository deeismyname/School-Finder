// import 'dart:convert';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'package:meta/meta.dart';

// part 'fetch_schools_state.dart';

// class FetchSchoolsCubit extends Cubit<FetchSchoolsState> {
//   FetchSchoolsCubit() : super(FetchSchoolsInitial());

//   // Track the list of all schools and pagination details
//   List<String> _allSchools = [];
//   int _currentPage = 1;
//   static const int _schoolsPerPage = 20; // Display 20 schools per page


//   void fetchSchools(String countryName) async {
//     try {
//       emit(FetchSchoolsLoading());

//       if (countryName.isEmpty) {
//         emit(FetchSchoolsError(
//             errorMessage: 'No country specified. Please enter a country.'));
//         return;
//       }

//       final response = await http.get(
//         Uri.parse(
//             'http://universities.hipolabs.com/search?country=$countryName'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         _allSchools = data.map((school) => school['name'] as String).toList();

//         // Print each school's details for debugging purposes
//         for (var school in data) {
//           print('School Name: ${school['name']}');
//           print('Alpha Code: ${school['alpha_two_code']}');
//           print('Country: ${school['country']}');
//           print('Web Pages: ${school['web_pages']}');
//           print('Domains: ${school['domains']}');
//           print('State/Province: ${school['state-province']}');
//           print('---');
//         }

//         if (_allSchools.isEmpty) {
//           emit(FetchSchoolsError(
//               errorMessage: 'No schools found for the specified country.'));
//         } else {
//           _currentPage = 1;
//           _emitSchoolsForPage();
//         }
//       } else {
//         // Handle the case where the HTTP request fails
//         emit(FetchSchoolsError(
//             errorMessage: 'Failed to load schools. Please try again.'));
//       }
//     } catch (e) {
//       // Catch the error and display the error message
//       emit(FetchSchoolsError(
//           errorMessage: 'An error occurred: ${e.toString()}'));
//     }
//   }

//   // Emit a page of schools based on the current page
//   void _emitSchoolsForPage() {
//     int startIndex = (_currentPage - 1) * _schoolsPerPage;
//     int endIndex = (_currentPage * _schoolsPerPage) > _allSchools.length
//         ? _allSchools.length
//         : (_currentPage * _schoolsPerPage);
//     List<String> schoolsToDisplay = _allSchools.sublist(startIndex, endIndex);

//     emit(FetchSchoolsLoaded(
//       schools: schoolsToDisplay,
//       searchQuery: '',
//       currentPage: _currentPage,
//       totalPages: (_allSchools.length / _schoolsPerPage).ceil(),
//     ));
//   }

//   // Update the search query and filter the schools
//   void updateSearchQuery(String query) {
//     if (state is FetchSchoolsLoaded) {
//       final currentState = state as FetchSchoolsLoaded;
//       emit(FetchSchoolsLoaded(
//         schools: currentState.schools,
//         searchQuery: query,
//         currentPage: currentState.currentPage,
//         totalPages: currentState.totalPages,
//       ));
//     }
//   }

//   // Load the next page of schools
//   void loadNextPage() {
//     if (_currentPage < (_allSchools.length / _schoolsPerPage).ceil()) {
//       _currentPage++;
//       _emitSchoolsForPage();
//     }
//   }

//   // Load the previous page of schools
//   void loadPreviousPage() {
//     if (_currentPage > 1) {
//       _currentPage--;
//       _emitSchoolsForPage();
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'fetch_schools_state.dart';

class FetchSchoolsCubit extends Cubit<FetchSchoolsState> {
  FetchSchoolsCubit() : super(FetchSchoolsInitial());

  // Track the list of all schools and pagination details
  List<Map<String, dynamic>> _allSchools = [];
  int _currentPage = 1;
  static const int _schoolsPerPage = 20; // Display 20 schools per page

  void fetchSchools(String countryName) async {
    try {
      emit(FetchSchoolsLoading());

      if (countryName.isEmpty) {
        emit(FetchSchoolsError(
            errorMessage: 'No country specified. Please enter a country.'));
        return;
      }

      final response = await http.get(
        Uri.parse(
            'http://universities.hipolabs.com/search?country=$countryName'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _allSchools = data.map((school) {
          return {
            'name': school['name'] as String,
            'website': (school['web_pages'] as List<dynamic>?)?.firstOrNull,
            'country': school['country'] as String,
             'state': school['state-province'] as String?,
          };
        }).toList();



        if (_allSchools.isEmpty) {
          emit(FetchSchoolsError(
              errorMessage: 'No schools found for the specified country.'));
        } else {
          _currentPage = 1;
          _emitSchoolsForPage();
        }
      } else {
        // Handle the case where the HTTP request fails
        emit(FetchSchoolsError(
            errorMessage: 'Failed to load schools. Please try again.'));
      }
    } catch (e) {
      // Catch the error and display the error message
      emit(FetchSchoolsError(
          errorMessage: 'An error occurred: ${e.toString()}'));
    }
  }

  // Emit a page of schools based on the current page
  void _emitSchoolsForPage() {
    int startIndex = (_currentPage - 1) * _schoolsPerPage;
    int endIndex = (_currentPage * _schoolsPerPage) > _allSchools.length
        ? _allSchools.length
        : (_currentPage * _schoolsPerPage);
    List<Map<String, dynamic>> schoolsToDisplay = _allSchools.sublist(startIndex, endIndex);

    emit(FetchSchoolsLoaded(
      schools: schoolsToDisplay,
      searchQuery: '',
      currentPage: _currentPage,
      totalPages: (_allSchools.length / _schoolsPerPage).ceil(),
    ));
  }

  // Update the search query and filter the schools
  void updateSearchQuery(String query) {
    if (state is FetchSchoolsLoaded) {
      final currentState = state as FetchSchoolsLoaded;
      emit(FetchSchoolsLoaded(
        schools: currentState.schools,
        searchQuery: query,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
      ));
    }
  }

  // Load the next page of schools
  void loadNextPage() {
    if (_currentPage < (_allSchools.length / _schoolsPerPage).ceil()) {
      _currentPage++;
      _emitSchoolsForPage();
    }
  }

  // Load the previous page of schools
  void loadPreviousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      _emitSchoolsForPage();
    }
  }
}