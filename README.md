# Todos App

Monorepo สำหรับ Todos application

## Structure

- `frontend/` - Flutter mobile/web app (Riverpod + Clean Architecture)
- `backend/`  - NestJS REST API
- `shared/`   - API contracts ที่ใช้ร่วมกัน (OpenAPI spec)

## Getting Started

### Backend
```bash
cd backend
npm install
npm run start:dev
```

### Frontend
```bash
cd frontend
flutter pub get
flutter run
```
