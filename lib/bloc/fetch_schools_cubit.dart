import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'fetch_schools_state.dart';

class FetchSchoolsCubit extends Cubit<FetchSchoolsState> {
  FetchSchoolsCubit() : super(FetchSchoolsInitial());

  // Track the list of all schools and pagination details
  List<String> _allSchools = [];
  int _currentPage = 1;
  static const int _schoolsPerPage = 20; // Display 20 schools per page

  // Fetch schools based on country
  void fetchSchools(String countryName) async {
    try {
      emit(FetchSchoolsLoading());

      // Make the HTTP request to the API
      final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=$countryName'),
      );

      if (response.statusCode == 200) {
        // Parse the response body
        List<dynamic> data = json.decode(response.body);
        _allSchools = data.map((school) => school['name'] as String).toList();

        if (_allSchools.isEmpty) {
          emit(FetchSchoolsEmpty());
        } else {
          // Paginate the schools for the first page
          _currentPage = 1;
          _emitSchoolsForPage();
        }
      } else {
        emit(FetchSchoolsError());
      }
    } catch (e) {
      emit(FetchSchoolsError());
    }
  }

  // Emit a page of schools based on the current page
  void _emitSchoolsForPage() {
    int startIndex = (_currentPage - 1) * _schoolsPerPage;
    int endIndex = (_currentPage * _schoolsPerPage) > _allSchools.length
        ? _allSchools.length
        : (_currentPage * _schoolsPerPage);
    List<String> schoolsToDisplay = _allSchools.sublist(startIndex, endIndex);

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
