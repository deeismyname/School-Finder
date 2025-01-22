# Flutter Developer Assignment

## Instructions to Set Up and Run the App

1. Clone the Repository:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. Install Dependencies:
   ```bash
   flutter pub get
   ```

3. Run the App:
   ```bash
   flutter run
   ```
   Ensure you have a connected device or an emulator running.

4. API Configuration:
   - No additional API configuration is required as the app uses a mock API.

---

## Approach

### Project Structure:
The project is modularized into the following layers:

1. **Data Layer**
   - Responsible for fetching data from the mock API.
   - Includes services and repositories for data handling.

2. **Business Logic Layer**
   - Uses the `bloc` package for state management.
   - Ensures separation of concerns and facilitates testing.

3. **Presentation Layer**
   - Contains screens and widgets.
   - Handles navigation using the `go_router` package.

### Key Features:
- **State Management**:
  - `bloc` manages states like loading, success, and error.
- **Routing**:
  - `go_router` enables smooth navigation between screens.
- **Error Handling**:
  - Displays appropriate messages for failed or empty API responses.
- **Performance Optimization**:
  - Efficient widget rebuilding and caching implementation.
- **UI Design**:
  - Responsive and visually appealing interfaces.

---

## Challenges Faced and Solutions

1. **Hardware Limitations**:
   - Challenge: Two PCs used initially could not run the project due to insufficient resources.
   - Solution: Upgraded to a more advanced PC with higher resources.

2. **Understanding Best Practices**:
   - Challenge: Navigating the app structure and adhering to best practices.
   - Solution: Conducted research and sought guidance to implement clean architecture and maintainability.

---
