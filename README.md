# Nexus Leafline - Plant Care Guidance App

A comprehensive Flutter application designed to help local plant nurseries provide better care instructions, reminders, and product details to their customers.

## Features

- **Plant Library**: Browse a curated collection of plants with detailed care instructions
- **Care Instructions**: Comprehensive watering, sunlight, and soil requirements for each plant
- **Reminders**: Set and manage personalized plant care reminders with local notifications
- **Beautiful UI**: Expert-level design with modern Material Design 3 aesthetics
- **Offline Support**: Local database storage for reminders and plant data

## Screenshots

[Add screenshots here when available]

## Getting Started

### Prerequisites

- Flutter SDK (3.10.7 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/tanveer128423/nexus_leafline.git
   cd nexus_leafline
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── models/
│   ├── plant.dart
│   └── reminder.dart
├── providers/
│   └── plant_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── plant_detail_screen.dart
│   └── reminders_screen.dart
├── services/
│   ├── database_service.dart
│   └── notification_service.dart
├── utils/
│   └── sample_data.dart
├── widgets/
│   └── plant_card.dart
└── main.dart
```

## Dependencies

- `provider`: State management
- `sqflite`: Local database
- `flutter_local_notifications`: Push notifications
- `cached_network_image`: Image caching
- `google_fonts`: Custom typography
- `intl`: Date/time formatting

## Architecture

The app follows a clean architecture pattern with:

- **Models**: Data structures for Plant and Reminder
- **Providers**: State management using Provider pattern
- **Services**: Database and notification services
- **Screens**: UI screens with navigation
- **Widgets**: Reusable UI components

## Future Enhancements

- Firebase integration for authentication and cloud sync
- Camera integration for plant identification
- Advanced reminder scheduling
- Nursery product catalog
- User plant collections

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
