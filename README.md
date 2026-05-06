# Todos Riverpod

A monorepo for a productivity app built with Flutter on the frontend, NestJS on the backend, and a shared OpenAPI contract.

The app started as a local-first Todo workspace and now includes authenticated routing, email signup with OTP verification, Google sign-in on mobile, session restore, and a shared API spec for auth and todo flows.

## What Is In This Repo

- `frontend/` Flutter app built with Riverpod and `go_router`
- `backend/` NestJS REST API with MongoDB and JWT auth
- `shared/` shared API contract in OpenAPI format

## Current Features

- Email/password sign in
- Email signup with OTP verification
- OTP resend flow with cooldown
- Mobile Google sign in
- Session restore on app launch
- Protected app routes based on auth state
- Todo workspace UI with local storage-backed data flow
- Shared API contract for auth and todo endpoints

## Monorepo Structure

```text
.
├── frontend/
├── backend/
└── shared/
```

### Frontend Structure

```text
frontend/lib/
  main.dart
  my_app.dart
  src/
    core/
      config/
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

This project uses a feature-first layered structure:

- `presentation` renders UI and handles user interaction
- `usecase` coordinates state and app actions
- `domain` defines entities and repository contracts
- `data` implements repositories and datasources
- `core` contains shared infrastructure such as env config, storage, network, and reusable widgets

Current app flow examples:

- Auth: `presentation -> usecase -> domain contract -> data repository -> remote datasource / secure storage`
- Todos: `presentation -> usecase -> domain contract -> data repository -> local datasource`

## Tech Stack

### Frontend

- Flutter
- Riverpod + `riverpod_annotation`
- `go_router`
- Dio
- `flutter_secure_storage`
- `google_sign_in`
- Hive CE
- Flutter Hooks / Hooks Riverpod
- Freezed + JSON Serializable

### Backend

- NestJS
- MongoDB + Mongoose
- JWT + Passport
- bcrypt
- Google Auth Library
- `class-validator` / `class-transformer`

## Current Screens

- `LoginScreen`
- `RegisterScreen`
- `VerifyEmailOtpScreen`
- `LandingScreen`
- `TodoScreen`

## Authentication Overview

Implemented auth endpoints:

- `POST /api/auth/check-email`
- `POST /api/auth/register`
- `POST /api/auth/verify-email-otp`
- `POST /api/auth/resend-email-otp`
- `POST /api/auth/login`
- `POST /api/auth/google`
- `POST /api/auth/refresh`
- `POST /api/auth/logout`
- `GET /api/auth/me`
- `PATCH /api/auth/profile`

### Email Signup Flow

1. User enters email and account details.
2. Backend creates or refreshes a pending account.
3. Backend sends a 6-digit OTP.
4. Frontend routes the user to OTP verification.
5. Tokens are issued only after OTP verification succeeds.

### OTP Behavior

- OTP length: 6 digits
- OTP expiry: 5 minutes
- Resend cooldown: 60 seconds
- Pending verification state is stored locally so the app can resume the flow after restart

### Development Email Sender

There is no production email provider wired into the repo yet.

In development and test, OTP delivery uses a mock sender that logs the code from:

- [backend/src/modules/auth/email-verification.sender.ts](/Users/overwhelmed/Desktop/WORK/todos_riverpod/backend/src/modules/auth/email-verification.sender.ts)

In production, the current sender only warns that no provider is configured.

## Getting Started

### Prerequisites

- Flutter SDK
- Node.js and npm
- MongoDB, local or hosted

## Backend Setup

Install dependencies:

```bash
cd backend
npm install
```

Create `backend/.env` from `backend/.env.example`.

Example values:

```env
NODE_ENV=development
MONGODB_URI=mongodb://127.0.0.1:27017/todos
PORT=3000
JWT_ACCESS_SECRET=your_local_dev_access_secret
JWT_REFRESH_SECRET=your_local_dev_refresh_secret
JWT_ACCESS_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=30d
GOOGLE_CLIENT_ID=your_google_oauth_client_id
```

Start the backend:

```bash
cd backend
npm run start:dev
```

The API runs at `http://localhost:3000/api`.

### Seed A Password User

If you want a test user for email/password login:

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

## MongoDB With Docker

Quick local MongoDB:

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

Persistent volume version:

```bash
docker run -d --name todos-mongo -p 27017:27017 -v todos-mongo-data:/data/db mongo:7
```

## Frontend Setup

Install dependencies:

```bash
cd frontend
flutter pub get
```

Create `frontend/.env` from `frontend/.env.example`.

Example values:

```env
API_BASE_URL=http://localhost:3000/api
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_SERVER_CLIENT_ID=your_google_server_client_id
```

Run the app:

```bash
cd frontend
flutter run
```

Notes:

- If `API_BASE_URL` is omitted, Android emulator defaults to `http://10.0.2.2:3000/api`
- Other platforms default to `http://localhost:3000/api`
- Google sign-in is currently enabled only for mobile builds in this app configuration

## Shared API Contract

The API spec lives here:

- [shared/api-contracts/todos.yaml](/Users/overwhelmed/Desktop/WORK/todos_riverpod/shared/api-contracts/todos.yaml)

It documents:

- auth request and response shapes
- OTP verification endpoints
- todo endpoints
- shared schema definitions used by frontend and backend as a common contract

## Code Generation

The frontend uses generated files for Riverpod, Freezed, JSON serialization, and Hive.

Run code generation:

```bash
cd frontend
dart run build_runner build --delete-conflicting-outputs
```

Watch mode:

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

Auth-focused tests:

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

Run all tests:

```bash
cd frontend
flutter test
```

Run auth-focused tests:

```bash
cd frontend
flutter test test/feature/auth
```

## Development Notes

- Do not manually edit generated files ending in `.g.dart` or `.freezed.dart`
- Keep routing centralized in `frontend/lib/src/router`
- Keep business logic out of widgets
- Prefer reusing shared theme, storage, and widgets before adding one-off infrastructure
- The shared OpenAPI file should be updated when request or response contracts change

## Version

- App version: `1.0.0+1`
