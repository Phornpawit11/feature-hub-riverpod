# Todos Riverpod

A minimal Flutter workspace built with Riverpod, GoRouter, Hive, and Freezed.

This project starts with a Todo feature and a landing screen that acts as a small feature hub, making it easy to grow the app with more tools over time.

## Features

- Landing screen as a feature hub
- Todo list with add, toggle, and delete actions
- Local persistence with Hive
- App-wide drawer for theme, language preference, and app info
- Centralized theme system with light and dark mode support

## Tech Stack

- Flutter
- Riverpod + `riverpod_annotation`
- GoRouter
- Hive CE
- Freezed + JSON Serializable
- Flex Color Scheme
- Flutter Hooks / Hooks Riverpod

## Project Structure

```text
lib/
  main.dart
  my_app.dart
  src/
    core/
      settings/
      storage/
      theme/
      widgets/
    feature/
      landing/
        presentation/
      todos/
        data/
        domain/
        presentation/
        usecase/
    router/
```

### Architecture Notes

This project follows a feature-first layered structure:

- `presentation` renders UI and collects user input
- `usecase` coordinates actions and state changes
- `domain` contains feature entities and contracts
- `data` implements repositories and talks to local storage
- `core` contains app-wide shared code such as theme, storage bootstrap, reusable widgets, and app preferences

For the Todo feature, the flow is:

`presentation -> usecase -> domain abstraction -> data implementation -> Hive datasource`

## Current Screens

- `LandingScreen`: app entry point and feature hub
- `TodoScreen`: todo list UI

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart SDK compatible with the Flutter version in use

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

## Code Generation

This project uses generated files for Riverpod, Freezed, JSON serialization, and Hive.

Run code generation with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous generation during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Quality Checks

Format code:

```bash
dart format .
```

Analyze code:

```bash
dart analyze
```

Run tests:

```bash
flutter test
```

## Theme And Preferences

The app uses a centralized theme setup under `lib/src/core/theme`.

App-wide preferences currently include:

- theme mode
- language preference

These are managed under `lib/src/core/settings`.

## Persistence

Todo data is stored locally with Hive.

Hive initialization happens during app bootstrap in `main.dart` before `runApp`.

## Adding A New Feature

When adding a new feature, prefer this structure:

```text
lib/src/feature/your_feature/
  data/
  domain/
  presentation/
  usecase/
```

If a feature starts small, begin with only the layers you actually need and grow it gradually.

## Development Notes

- Do not manually edit generated files ending in `.g.dart` or `.freezed.dart`
- Reuse shared theme and widgets before adding one-off styling
- Keep navigation centralized in `lib/src/router`
- Keep business logic out of widgets

## Version

- App version: `1.0.0+1`
