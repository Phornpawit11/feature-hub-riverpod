# Todos Riverpod

A monorepo for a small productivity app built around Flutter on the frontend, NestJS on the backend, and a shared OpenAPI contract.

The project started as a local-first Todo app and now includes a first-pass authentication flow with email/password login, mobile Google sign-in, and session restore on app launch.

## Features

- Login screen with email/password authentication
- Google sign-in for mobile builds
- Protected Todo route with auth-aware redirects
- Todo workspace UI built with Riverpod and go_router
- Local frontend preferences and storage helpers
- NestJS backend with MongoDB, JWT auth, and Google token verification
- Shared API contract under `shared/api-contracts`

## Monorepo Structure

```text
.
├── frontend/   Flutter app
├── backend/    NestJS REST API
└── shared/     Shared contracts and specs
```

### Frontend Structure

```text
frontend/lib/
  main.dart
  my_app.dart
  src/
    core/
      network/
      settings/
      storage/
      theme/
      widgets/
    feature/
      auth/
        data/
        domain/
        presentation/
        usecase/
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
- `domain` contains entities and contracts
- `data` implements repositories and talks to remote or local datasources
- `core` contains shared app infrastructure such as theme, API client, storage, and reusable widgets

For the auth feature, the flow is:

`presentation -> usecase -> domain abstraction -> data implementation -> remote datasource / secure storage`

For the Todo feature, the current flow is:

`presentation -> usecase -> domain abstraction -> data implementation -> local datasource`

## Tech Stack

### Frontend

- Flutter
- Riverpod + `riverpod_annotation`
- go_router
- Dio
- flutter_secure_storage
- google_sign_in
- Hive CE
- Flex Color Scheme
- Flutter Hooks / Hooks Riverpod

### Backend

- NestJS
- Mongoose + MongoDB
- JWT + Passport
- bcrypt
- Google Auth Library
- class-validator / class-transformer

## Current Screens

- `LoginScreen`: email/password login and mobile Google sign-in
- `LandingScreen`: feature hub
- `TodoScreen`: authenticated Todo workspace

## Authentication Flow

Currently implemented:

- `POST /api/auth/login`
- `POST /api/auth/google`
- `GET /api/auth/me`

Session behavior:

- app startup restores a stored token
- valid token redirects to `/todo`
- unauthenticated users are redirected to `/login`
- authenticated users are redirected away from `/login`

Current scope:

- login only
- no sign up yet
- no forgot password yet
- no refresh token yet
- no logout API yet

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart SDK compatible with the Flutter version in use
- Node.js and npm
- MongoDB, either local, Docker, or Atlas

## Backend Setup

Install dependencies:

```bash
cd backend
npm install
```

Create `backend/.env` from `backend/.env.example` and set:

```env
MONGODB_URI=your_mongodb_uri
PORT=3000
JWT_SECRET=your_local_dev_secret
GOOGLE_CLIENT_ID=your_google_oauth_client_id
```

Start the backend:

```bash
cd backend
npm run start:dev
```

### Seed A Password User For Login Testing

If you want a test user for the email/password flow:

```bash
cd backend
npm run seed:password-user
```

Default seeded credentials:

- email: `test@example.com`
- password: `password123`

Optional overrides:

```bash
cd backend
SEED_USER_EMAIL='demo@example.com' \
SEED_USER_PASSWORD='secret123' \
SEED_USER_DISPLAY_NAME='Demo User' \
npm run seed:password-user
```

The seed script reads `MONGODB_URI` from the current shell, then falls back to `backend/.env`, then falls back to `mongodb://127.0.0.1:27017/todos`.

## MongoDB With Docker

If you want a quick local MongoDB instance:

```bash
docker run -d --name todos-mongo -p 27017:27017 mongo:7
```

Useful commands:

```bash
docker ps
docker stop todos-mongo
docker start todos-mongo
docker logs todos-mongo
```

To persist MongoDB data across container recreation:

```bash
docker run -d --name todos-mongo -p 27017:27017 -v todos-mongo-data:/data/db mongo:7
```

## Frontend Setup

Install dependencies:

```bash
cd frontend
flutter pub get
```

Create `frontend/.env` from `frontend/.env.example`, then run the app:

```bash
cd frontend
flutter run
```

Frontend runtime env:

```env
API_BASE_URL=http://localhost:3000/api
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_SERVER_CLIENT_ID=your_google_server_client_id
```

Notes:

- Android emulator defaults to `http://10.0.2.2:3000/api`
- other platforms default to `http://localhost:3000/api`
- Google sign-in is currently enabled only for mobile builds

## Shared API Contract

The shared auth and todo contract lives here:

```text
shared/api-contracts/todos.yaml
```

This spec documents:

- auth login
- Google login
- current user lookup
- todo endpoints

## Code Generation

The frontend uses generated files for Riverpod, Freezed, JSON serialization, and Hive.

Run code generation with:

```bash
cd frontend
dart run build_runner build --delete-conflicting-outputs
```

For continuous generation during development:

```bash
cd frontend
dart run build_runner watch --delete-conflicting-outputs
```

## Quality Checks

### Backend

Build:

```bash
cd backend
npm run build
```

Run auth-focused tests:

```bash
cd backend
npm run test:auth
```

### Frontend

Format:

```bash
cd frontend
dart format .
```

Analyze:

```bash
cd frontend
dart analyze
```

Run tests:

```bash
cd frontend
flutter test
```

## Development Notes

- Do not manually edit generated files ending in `.g.dart` or `.freezed.dart`
- Keep navigation centralized in `frontend/lib/src/router`
- Keep business logic out of widgets
- Reuse shared theme and widgets before adding one-off styling
- Auth route protection currently lives in the app router

## Version

- App version: `1.0.0+1`
