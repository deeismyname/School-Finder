part of 'fetch_schools_cubit.dart';

@immutable
abstract class FetchSchoolsState {}

class FetchSchoolsInitial extends FetchSchoolsState {}

class FetchSchoolsLoading extends FetchSchoolsState {}

class FetchSchoolsEmpty extends FetchSchoolsState {}

class FetchSchoolsError extends FetchSchoolsState {}

class FetchSchoolsLoaded extends FetchSchoolsState {
  final List<String> schools;
  final String searchQuery;
  final int currentPage;
  final int totalPages;

  FetchSchoolsLoaded({
    required this.schools,
    required this.searchQuery,
    required this.currentPage,
    required this.totalPages,
  });
}
