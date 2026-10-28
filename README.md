# Blood Donor Emergency Network (Flutter SDG Project)

A student prototype aligned with UN Sustainable Development Goal 3: Good Health and Well-being.

## Current features
- Home screen with project statistics and navigation
- Register a potential donor with basic form validation and consent checkbox
- Search sample donors by blood group and city
- Create and view emergency blood requests
- SDG 3 information page
- Red-and-white Material 3 interface

## Requirements
- Flutter SDK (stable)
- Android Studio or VS Code with Flutter and Dart extensions
- Android emulator or a USB-debuggable Android phone

## Run the app
1. Install Flutter and verify the setup:
   ```bash
   flutter doctor
   ```
2. Extract this project folder.
3. Open the `blood_donor_emergency_network` folder in VS Code.
4. Open Terminal > New Terminal and run:
   ```bash
   flutter pub get
   flutter run
   ```
5. Select your emulator or connected phone if prompted.

## Important limitations
This is a classroom prototype. Data is stored in memory only and resets after restart. It does not send notifications, verify donor eligibility, or contact hospitals. Do not publish real phone numbers or sensitive information. Before production use, add authentication, a secure backend/database, consent and privacy controls, server-side validation, abuse reporting, and appropriate medical/safety review.

## GitHub submission
Create a new **public** repository named `blood-donor-emergency-network` (unless your faculty requires private). Upload the project files, keeping `lib/main.dart`, `pubspec.yaml`, and this README at the repository root structure. Do not upload build output, `.dart_tool`, local secrets, or real user data.

## Suggested evaluation demo
1. Show the home screen.
2. Register a sample donor using fictional data.
3. Search by blood group and city.
4. Create a fictional emergency request.
5. Open Requests and show the request card.
6. Explain SDG 3 relevance and prototype limitations.
