import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/fetch_schools_cubit.dart';
import 'package:country_picker/country_picker.dart';
import 'package:go_router/go_router.dart';
// import 'school_details_page.dart';
import 'package:untitled/presentation/home_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schools by Country"),
      ),
      body: Column(
        children: [
          // Row to contain both the Select Country button and the search field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Button to select country
                ElevatedButton(
                  onPressed: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false, // Optional. Show phone code next to country name.
                      onSelect: (Country country) {
                        // Fetch schools based on the selected country
                        context.read<FetchSchoolsCubit>().fetchSchools(country.name);
                      },
                    );
                  },
                  child: const Text("Select Country"),
                ),
                const SizedBox(width: 16), // Space between button and search field
                // Search TextField to filter schools
                Expanded(
                  child: TextField(
                    onChanged: (query) {
                      // Update search query and filter schools
                      context.read<FetchSchoolsCubit>().updateSearchQuery(query);
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
          // Display list of schools or a message if no schools are found
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
                    return school.toLowerCase().contains(state.searchQuery.toLowerCase());
                  }).toList();

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredSchools.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                title: Text(filteredSchools[index],
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                trailing: ElevatedButton(
                                  // onPressed: () {
                                  //   // Navigate to the school details page using GoRouter
                                  //   context.push(
                                  //     '/school-details',
                                  //     extra: filteredSchools[index],
                                  //   );
                                  // },
                                  onPressed: () {
                                    // Create a school object or pass its details (e.g., the entire object)
                                    final schoolDetails = filteredSchools[index]; // Or, use a custom object with all details

                                    // Navigate to the school details page and pass the school details
                                    context.push(
                                      '/school-details',
                                      extra: schoolDetails,  // Pass the school details as extra
                                    );
                                  },

                                  child: const Text("More"),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Redesigned Pagination Controls
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Previous button
                            _buildPaginationButton(
                              context: context,
                              icon: Icons.arrow_back,
                              onPressed: () {
                                context.read<FetchSchoolsCubit>().loadPreviousPage();
                              },
                            ),
                            const SizedBox(width: 16),
                            // Page number display
                            Text(
                              '${state.currentPage} / ${state.totalPages}',
                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 16),
                            // Next button
                            _buildPaginationButton(
                              context: context,
                              icon: Icons.arrow_forward,
                              onPressed: () {
                                context.read<FetchSchoolsCubit>().loadNextPage();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text("An error occurred. Please try again."),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create pagination buttons
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
