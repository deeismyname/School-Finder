import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/fetch_schools_cubit.dart';
import 'package:country_picker/country_picker.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schools Finder"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      onSelect: (Country country) {
                        context
                            .read<FetchSchoolsCubit>()
                            .fetchSchools(country.name);
                      },
                    );
                  },
                  child: const Text("Select Country"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    onChanged: (query) {
                      context
                          .read<FetchSchoolsCubit>()
                          .updateSearchQuery(query);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search Schools',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<FetchSchoolsCubit, FetchSchoolsState>(
              builder: (context, state) {
                if (state is FetchSchoolsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is FetchSchoolsEmpty) {
                  return const Center(
                    child: Text("No schools found. Please select a country."),
                  );
                } else if (state is FetchSchoolsLoaded) {
                  final filteredSchools = state.schools.where((school) {
                    final schoolName = school['name'] as String;
                     return schoolName
                          .toLowerCase()
                          .contains(state.searchQuery.toLowerCase());
                  }).toList();


                  if (filteredSchools.isEmpty) {
                    return const Center(
                      child: Text("No schools match the search criteria."),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredSchools.length,
                          itemBuilder: (context, index) {
                             final school = filteredSchools[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                title: Text(school['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    context.push(
                                      '/school-details',
                                      extra: school,
                                    );
                                  },
                                  child: const Text("More"),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPaginationButton(
                              context: context,
                              icon: Icons.arrow_back,
                              onPressed: () {
                                context
                                    .read<FetchSchoolsCubit>()
                                    .loadPreviousPage();
                              },
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${state.currentPage} / ${state.totalPages}',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 16),
                            _buildPaginationButton(
                              context: context,
                              icon: Icons.arrow_forward,
                              onPressed: () {
                                context
                                    .read<FetchSchoolsCubit>()
                                    .loadNextPage();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (state is FetchSchoolsError) {
                  return Center(
                    child: Text(
                      state.errorMessage.isNotEmpty
                          ? state.errorMessage
                          : "An error occurred. Please try again.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Select a country to begin."),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 30.0),
      onPressed: onPressed,
      splashColor: Colors.blueAccent,
      highlightColor: Colors.blueAccent,
    );
  }
}