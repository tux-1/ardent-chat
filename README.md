# Ardent Chat

Ardent Chat is a lightweight, real-time messaging application designed for quick, secure, and user-friendly communication. Built with Firebase for authentication, real-time messaging, and media storage, Ardent Chat allows users to create an account, connect with contacts, and start chatting instantly.
<p float="right">
  <img src="https://github.com/tux-1/ardent-chat/blob/main/assets/images/Logo-Icon.png?raw=true" alt="Logo" width="200" />
</p>

## How to Set up
1. **Clone the Repository:** Clone this repository to your local machine.
```
git clone https://github.com/tux-1/ardent-chat
cd ardent_chat
```
2. **Install Flutter Packages:** Run `flutter pub get` to install all required dependencies.
3. **Configure Firebase:**
- Go to the Firebase Console, create a new Firebase project (or use an existing one).
- Download the `google-services.json` file for Android and place it in the android/app directory.
- Download the `GoogleService-Info.plist` file for iOS and place it in the ios/Runner directory.
- Run `flutterfire configure` in the root of the project to set up Firebase for Flutter automatically.
4. **Run the Application:**  Start the app with:
  ```
  flutter run
  ```

## Requirements 
- **Flutter SDK:** Version 3.0 or higher
- **Dart SDK:** Version 2.18 or higher
- **Firebase:** Ensure that your Firebase project is created, and the necessary Firebase services (Firestore, Authentication, and Storage) are enabled.
- **Minimum SDK for Android:** 23 (as per Firebase requirements)
- **Dependencies:** Packages listed in `pubspec.yaml`

## Features
- **Quick Signup and Login:** Authenticate with your email and start chatting.
- **Real-Time Messaging:** Send and receive messages in real-time with a smooth user experience.
- **Media Sharing:** Attach and send images alongside text messages.
- **Contact Search:** Easily find contacts by their names.
- **Seen Status:** Users can see if their messages have been read, enhancing communication clarity.
- **Profile Management:** Update profile information, including name and profile picture.
- **Light/Dark Theme:** Toggle between light and dark themes for a customized appearance.

## Screenshots
<p float="left">
  <img src="https://github.com/user-attachments/assets/27d3cb06-58b7-424d-aed1-d2228624ab2f" alt="onboarding" width="200" />
  <img src="https://github.com/user-attachments/assets/3ab7cafa-e61f-4da7-a47f-21e2ea3c9e39" alt="login" width="200" />
  <img src="https://github.com/user-attachments/assets/a721e412-545e-4973-af91-3792a152b494" alt="home-chat" width="200" />
  <img src="https://github.com/user-attachments/assets/e467a993-e911-4824-9fcf-0c02cc8f9eb1" alt="home-settings" width="200" />
</p>

<p float="left">
  <img src="https://github.com/user-attachments/assets/a4845aac-b24c-41a5-8f3c-ce8411c65c0d" alt="add-friend" width="200" />
  <img src="https://github.com/user-attachments/assets/e42b258d-ea8a-463f-89fd-4a186144da52" alt="chat-screen" width="200" />
</p>


