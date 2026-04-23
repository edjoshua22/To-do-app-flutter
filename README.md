# Todo App — Laravel + Flutter Integration

A minimalist Todo application with a **Laravel 10 REST API** backend and **Flutter** frontend.

---

## Project Structure

```
To-do-app-flutter/
├── todo_api/          ← Laravel 10 backend (REST API)
└── to_do_app/         ← Flutter frontend
```

---

## Backend Setup (Laravel)

### Prerequisites
- PHP 8.1+
- Composer
- MySQL (XAMPP / WAMP / Laragon)

### Steps

```bash
# 1. Enter the backend directory
cd todo_api

# 2. Install PHP dependencies
composer install

# 3. Copy and configure the environment file
cp .env.example .env

# 4. Generate the application key
php artisan key:generate

# 5. Create the MySQL database
#    Open MySQL and run: CREATE DATABASE todo_db;

# 6. Run database migrations
php artisan migrate

# 7. Start the development server
php artisan serve
```

The API will be available at **http://localhost:8000/api**

---

## API Endpoints

| Method | Endpoint              | Description        |
|--------|-----------------------|--------------------|
| GET    | `/api/todos`          | Fetch all todos    |
| POST   | `/api/todos`          | Create a new todo  |
| PUT    | `/api/todos/{id}`     | Update a todo      |
| DELETE | `/api/todos/{id}`     | Delete a todo      |

### Response Format

All responses follow this consistent JSON structure:

```json
{
  "status": "success",
  "message": "Todos fetched successfully.",
  "data": [...]
}
```

---

## Flutter Setup

### Prerequisites
- Flutter SDK 3.x
- Android Studio / VS Code
- Android Emulator or physical device

### Steps

```bash
# 1. Enter the Flutter project
cd to_do_app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Base URL Configuration

Edit `lib/services/api_service.dart` and set the correct base URL:

```dart
// Android Emulator
static const String _baseUrl = 'http://10.0.2.2:8000/api';

// iOS Simulator
static const String _baseUrl = 'http://localhost:8000/api';

// Physical Device (use your machine's LAN IP)
static const String _baseUrl = 'http://192.168.x.x:8000/api';
```

---

## Architecture

### Laravel (MVC)

```
todo_api/
├── app/
│   ├── Http/Controllers/
│   │   └── TodoController.php    ← CRUD logic
│   ├── Models/
│   │   └── Todo.php              ← Eloquent model
│   └── Providers/
│       └── AppServiceProvider.php
├── database/
│   ├── migrations/
│   │   └── create_todos_table.php
│   └── seeders/
├── routes/
│   └── api.php                   ← API routes
└── config/
    ├── cors.php                  ← CORS (open for Flutter)
    └── database.php
```

### Flutter (Clean Architecture)

```
to_do_app/lib/
├── models/
│   └── task_model.dart           ← Task data class + fromJson/toJson
├── services/
│   ├── api_service.dart          ← Dio HTTP client → Laravel API
│   └── task_service.dart         ← Business logic facade
├── screens/
│   ├── task_list_screen.dart     ← Home screen (fetch, delete, toggle)
│   └── add_task_screen.dart      ← Add / edit task screen
├── widgets/
│   ├── task_tile.dart            ← Individual task row
│   ├── dismissible_task_tile.dart← Swipe-to-delete wrapper
│   ├── task_list_header.dart     ← Header with date & progress
│   ├── week_day_selector.dart    ← Horizontal week strip
│   ├── task_options_card.dart    ← Alarm/reminder/priority pickers
│   └── empty_state_widget.dart   ← Shown when no tasks exist
├── theme/
│   └── app_theme.dart            ← Colours and Material theme
└── utils/
    ├── date_formatter.dart
    ├── dialog_utils.dart
    └── picker_utils.dart
```

---

## Todo Model Fields

| Field          | Type    | Notes              |
|----------------|---------|--------------------|
| `id`           | int     | Auto-increment PK  |
| `title`        | string  | Required           |
| `description`  | text    | Nullable           |
| `is_completed` | boolean | Default: `false`   |
| `created_at`   | timestamp | Auto             |
| `updated_at`   | timestamp | Auto             |

---

## CORS

CORS is fully open for local development. See `config/cors.php`:

```php
'allowed_origins' => ['*'],
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
```

Restrict `allowed_origins` before deploying to production.