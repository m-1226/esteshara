
# Esteshara

A Flutter-based mobile application designed to connect users with specialists for consultation and appointment booking, leveraging Firebase as the backend.

## Getting Started

Esteshara provides a seamless experience for finding and scheduling consultations with professionals like cardiologists or business consultants. Below are the steps to set up and run the project.

## Features

- **User Authentication**: Register, log in, and log out using Firebase Authentication with Google Sign-In support.
- **Specialist Listing**: Displays specialists with their name, specialization (e.g., Cardiologist, Business Consultant), available working days/times, and optional bio.
- **Appointment Booking**: Users can view available specialists, select a date and time, and confirm appointments.
- **Appointment Management**: View upcoming appointments, cancel, or reschedule appointments.
- **Advanced Search and Filters**: Group specialists by specialization and search by name or specialization.

## Setup Instructions

### Prerequisites

- **Flutter SDK**: Version 3.x (ensure `flutter --version` returns >= 3.1.3).
- **Dart**: Compatible with SDK >= 3.1.3 < 4.0.0.
- **Firebase Account**: Required for authentication and Firestore.
- **IDE**: Android Studio or VS Code with Flutter/Dart plugins.
- **Git**: To clone the repository.

### Steps

1. **Clone the Repository**:

    ```bash
    git clone https://github.com/your-username/esteshara.git
    cd esteshara
    ```

2. **Install Dependencies**:

    ```bash
    flutter pub get
    ```

3. **Configure Firebase**:

    - Create a Firebase project at [Firebase Console](https://console.firebase.google.com).
    - Add Android and iOS apps:
        - **Android**: Place `google-services.json` in `android/app/`.
        - **iOS**: Place `GoogleService-Info.plist` in `ios/Runner/`.

    - Enable Firebase Authentication (Email/Password, Google Sign-In) and Cloud Firestore.

    - **Important for Google Sign-In**:
        - You must add your app’s **SHA-1 fingerprint** in Firebase Project Settings.
        - Run the following command from your project’s `android/` directory:

        ```bash
        ./gradlew signingReport
        ```

        - Copy the `SHA1` value from the `debug` variant and paste it into Firebase > Project Settings > Your App > Add Fingerprint.
        - Download the updated `google-services.json` and replace the one in `android/app/`.

    - Update `android/build.gradle.kts` and `ios/Runner/Info.plist` per Firebase instructions.

4. **Run the App**:

    ```bash
    flutter run
    ```

5. **Build for Release**:

    - **Android**:

        ```bash
        flutter build apk --release
        ``` 

## App Architecture

Esteshara follows a modular, clean architecture to ensure scalability and maintainability.

### Core Layer (`lib/core/`):

- **Cubits**: Manages state with `flutter_bloc`.
- **Models**: Data models like `UserModel`, `AppointmentModel`, `SpecialistModel`.
- **Services**: Firebase integrations and dependency injection via `get_it`.
- **Utils**: Reusable utilities for assets, colors, themes, and routing.

### Features Layer (`lib/features/`):

Modular features (e.g., auth, home, appointments):

- **Data**: Cubits, repositories, and models.
- **Presentation**: Views and widgets using `BlocBuilder` for state updates.

### State Management

- **Bloc**: Handles complex state.
- **GetIt**: For dependency injection.

### Navigation

- **GoRouter**: Manages screen routing.
- **PersistentBottomNavBarV2**: For persistent bottom navigation.

### Firebase Integration

- **Authentication**: Firebase Auth for user registration, login, and Google Sign-In.
- **Firestore**: Stores specialist data, user profiles, and appointments.
- **Real-time Updates**: Firestore streams for live data.

### UI/UX

- Custom widgets for consistent styling.
- Lottie animations and SVGs for visuals.
- Light/Dark mode support.

## Business Requirements Understanding

### Business Goal

Esteshara aims to simplify access to professional consultations by connecting users with specialists in healthcare, business, and other fields. It provides a secure platform for scheduling and managing appointments, reducing barriers to expert advice.

### User Experience Thought Process

To improve the booking experience, a valuable feature is sending appointment reminders directly via WhatsApp or SMS. This ensures users receive timely notifications on platforms they already use, significantly reducing no-shows. Offering users the ability to choose their preferred reminder method during booking enhances personalization and reliability.

## Known Limitations

- **No Calendar Sync**: Users cannot yet add appointments to external calendars like Google Calendar or Apple Calendar.
- **No Push Notifications**: The app does not currently send push reminders; it relies on UI views and planned WhatsApp/SMS support.
- **No Payment Integration**: The booking flow assumes free consultations; no payment or billing system is integrated yet.
- **Basic Validation Rules**: Appointment booking logic could be extended to handle more complex scenarios (e.g., overlapping bookings, specialist cancellation policies).
- **Limited Localization**: The app currently supports only one language; expanding to Arabic or other languages would improve accessibility.

## Video Walkthrough

Video Walkthrough: [Video Walkthrough](https://youtu.be/ippQRqF-dZk)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
