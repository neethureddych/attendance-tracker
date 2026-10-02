# Attendance Tracker

A Flutter-based Attendance Tracker application that helps manage students and track their daily attendance.

## Features

- **Dashboard:** View attendance summaries and quick actions.
- **Student Management:** View and add students.
- **Mark Attendance:** Mark students as present or absent.
- **Attendance Summary:** View attendance information.
- **Local Persistence:** Save student and attendance data using SharedPreferences.
- **API Integration:** Fetch sample user data from a REST API.
- **Animation Demo:** Explore Flutter animations.
- **State Management:** Manage app data using Provider.
- **Automated Tests:** Unit tests for attendance management and a widget test for app startup.

## Technologies Used

- Flutter
- Dart
- Provider
- SharedPreferences
- HTTP / REST API
- Flutter Test
- Git and GitHub

## Getting Started

### Prerequisites

Install Flutter and configure the Flutter SDK on your computer.

Verify your installation:

```bash
flutter doctor
```

### Installation

1. Clone the repository:

```bash
git clone https://github.com/neethureddych/attendance-tracker.git
```

2. Open the project directory:

```bash
cd attendance-tracker
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the application in Chrome:

```bash
flutter run -d chrome --web-port 8080
```

## Running Tests

Run all automated tests:

```bash
flutter test
```

Check the project for code issues:

```bash
flutter analyze
```

## Project Structure

```text
attendance-tracker/
├── lib/
│   ├── main.dart
│   ├── add_student_screen.dart
│   ├── animations_screen.dart
│   ├── api_users_screen.dart
│   ├── providers/
│   │   └── attendance_provider.dart
│   └── theme/
│       └── app_theme.dart
├── test/
│   ├── attendance_provider_test.dart
│   └── widget_test.dart
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

## Learning Objectives

This project demonstrates Flutter UI development, state management, navigation, REST API integration, local data persistence, and automated testing.

## Future Improvements

- Add student profile editing and deletion.
- Add attendance history and date-based reports.
- Export attendance reports.
- Improve the user interface and responsiveness.
- Add authentication and cloud synchronization.

## Author

**Neethureddych**

GitHub: [@neethureddych](https://github.com/neethureddych)

## License

This project is available for educational and learning purposes.
