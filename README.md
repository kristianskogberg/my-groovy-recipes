# My Groovy Recipes

A recipe mobile app created with Flutter and Dart.

# How to run the project

This guide will walk you through the steps to run this Flutter project from your repository on your development environment. This guide was generated using ChatGPT.

## Prerequisites

Before you begin, ensure you have the following prerequisites installed on your system:

1. **Flutter SDK**: Download and install the Flutter SDK from the official Flutter website. Follow the installation instructions for your operating system.

2. **Android Studio or Xcode**: Install Android Studio with the Flutter and Dart plugins for Android development, or Xcode for iOS development.

3. **Editor**: Choose a code editor of your preference. Recommended editors are Visual Studio Code or Android Studio (with Flutter and Dart plugins).

4. **Git**: Install Git on your system for version control.

## Steps to Run the "My Groovy Recipes" Project

1. **Clone the Repository**: Open a terminal or command prompt and clone this repository using Git:

   ```bash
   git clone https://github.com/kristianskogberg/my-groovy-recipes.git
   ```

2. **Add Flutter to PATH**: Add the Flutter SDK path to your system environment variables to access the Flutter tools globally. Update your `.bashrc`, `.bash_profile`, or `.zshrc` file (based on your shell) with the following line:

   ```bash
   export PATH="$PATH:<your_flutter_sdk_path>/flutter/bin"
   ```

3. **Update Flutter**: Run the following command to download the necessary packages and dependencies:

   ```bash
   flutter doctor
   ```

4. **Install Flutter and Dart Plugins in your IDE**: If you're using Visual Studio Code, open it, navigate to the Extensions view, and search for "Flutter" and "Dart." Install both plugins.

5. **Open the Project in your IDE**: Open your chosen code editor (e.g., Visual Studio Code) and use the "Open Folder" option to select the "my-groovy-recipes" Flutter project's root folder.

6. **Connect a Device**: Connect a physical device via USB or set up an emulator/simulator to run the Flutter app. To verify available devices, use:

   ```bash
   flutter devices
   ```

7. **Run Your App**: Once your device is connected or the emulator/simulator is running, use the following command to run the "My Groovy Recipes" Flutter app:

   ```bash
   flutter run
   ```

If everything goes well, the "My Groovy Recipes" Flutter project should be launched on the selected device.

## Official Flutter documentation and help

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
