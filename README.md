# 📌 Homework Reminder App

A **Flutter** application to help users manage their homework reminders. The app supports **offline & online synchronization** using **Hive** for local storage and **Firebase (Cloud Firestore & Authentication)** for cloud backup and user authentication.

## ✨ Features

- 📅 **Home Screen**: Displays all reminders with their respective categories.
- 📂 **Category Management**: Organize reminders into different categories, showing the number of tasks per category.
- 🕒 **History Section**: View past-due reminders.
- 🔄 **Offline & Online Sync**: Automatically syncs data between local storage (Hive) and Firebase Cloud Firestore.
- 🔐 **User Authentication**: Secure login/signup with Firebase Authentication.
- ☁ **Cloud Backup & Restore**: Ensures reminders are backed up and accessible across devices.

## 🛠️ Tech Stack

- **Flutter** (Dart)
- **Hive** (Local Database)
- **Firebase** (Cloud Firestore & Authentication)

## 🚀 Getting Started

### 1️⃣ Prerequisites
Make sure you have the following installed:
- Flutter SDK
- Dart
- Firebase CLI (for Firebase setup)

### 2️⃣ Installation
```sh
# Clone the repository
git clone https://github.com/yourusername/homework-reminder.git
cd homework-reminder

# Install dependencies
flutter pub get
```

### 3️⃣ Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
2. Enable **Firestore Database** & **Firebase Authentication**.
3. Download `google-services.json` (for Android) and place it in `android/app/`.
4. For iOS, add `GoogleService-Info.plist` to `ios/Runner/`.
5. Enable **offline persistence** for Firestore in `firebase_options.dart`.

### 4️⃣ Run the App
```sh
flutter run
```

## 📷 Screenshots

![Home Screen](https://via.placeholder.com/600x300?text=Home+Screen)
![Login Screen](https://via.placeholder.com/600x300?text=Login+Screen)

## ⚠️ Note
🚧 *This app is currently in Indonesian.*

---
💡 Feel free to contribute! Fork the repo and submit a PR. 😊

