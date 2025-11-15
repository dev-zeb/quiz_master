# Learn with Quizzes

A Flutter application for creating and taking quizzes. This app allows users to create their own quizzes with multiple-choice questions and take quizzes created by others.

## Features

- Create custom quizzes with multiple-choice questions
- Dynamic option management for questions
- Beautiful gradient UI with modern design
- Take quizzes and see results immediately
- Track correct and incorrect answers
- Retry quizzes to improve scores

## Technical Details

### Architecture
- Clean folder structure with separate UI, models, and configuration
- Centralized theme management
- Reusable widgets for consistent UI
- Proper state management

### Project Structure
```
lib/
├── config/         # App configurations
│   ├── colors.dart
│   ├── strings.dart
│   ├── text_styles.dart
│   └── theme.dart
├── models/         # Data models
├── ui/            # User interface
│   ├── screens/   # App screens
│   └── widgets/   # Reusable widgets
└── main.dart      # Entry point
```

## Getting Started

1. Clone the repository:
```bash
git clone https://github.com/dev-zeb/quiz_master.git
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Requirements

- Flutter SDK
- Dart SDK
- Android Studio / VS Code with Flutter extensions

## Contributing

Feel free to submit issues and enhancement requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
