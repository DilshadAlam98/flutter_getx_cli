# Flutter GetX CLI

**Accelerate your Flutter development with the ultimate CLI for the GetX pattern.**

`flutter_getx_cli` is a powerful command-line tool designed to automate the creation of GetX modules, routes, and pages. It adheres to a clean architecture, ensuring your project structure remains scalable and maintainable.

## 🚀 Features

- **Automated Module Generation**: Create Controllers, Bindings, and Views in one go.
- **Project Initialization**: Instantly set up core structure (Components, Theme, Utils, Constants).
- **Smart Routing**: Automatically injects new routes into `app_routes.dart` and `app_pages.dart`.
- **Clean Architecture**: Enforces a standard folder structure (`lib/app/modules/...`).
- **Flexible Management**: Easily remove modules and their associated routes.
- **Customizable**: Options to skip route generation or only remove routes.
- **Network & Local Config**: Generates Dio client, interceptors, API constants, and SharedPreferences helpers.

## 📦 Installation

Install the CLI globally using Dart:

```bash
dart pub global activate flutter_getx_cli
```

Ensure your global package bin directory is in your system's PATH (see [Troubleshooting](#troubleshooting)).

## 🛠 Usage

The general syntax is:

```bash
flutter_getx_cli <command> [arguments] [options]
```

### 1. Initialize Project Structure

Sets up the core folder structure and essential files for your GetX project. This is typically run once at the beginning of a project.

**Command:**

```bash
flutter_getx_cli init
```

**Generated Structure:**

It creates the following structure and files:

```
lib/app/
├── core/
│   ├── components/          # Reusable UI components
│   │   ├── primary_button.dart
│   │   ├── primary_dropdown.dart
│   │   └── primary_textfield.dart
│   ├── theme/               # App theme configuration
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart   # Light & Dark themes
│   │   └── text_styles.dart
│   ├── utils/
│   │   ├── app_utils.dart   # GetUtils wrappers
│   │   └── dialog_utils.dart# Alerts, confirm, loading dialogs
│   └── constants/
│       ├── app_constants.dart
│       ├── string_constants.dart
│       └── global_constants.dart
├── config/
│   ├── network/
│   │   ├── dio_client.dart              # Preconfigured Dio client
│   │   ├── api_constants.dart           # Base URL + endpoints
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart    # Injects Authorization header
│   │       └── logger_interceptor.dart  # Basic request/response logging
│   └── local/
│       └── shared_prefs.dart            # Typed SharedPreferences helpers
└── routes/
    ├── app_pages.dart                   # List<GetPage>
    └── app_routes.dart                  # Route constants
```

**Network Usage Example:**

```dart
import 'package:dio/dio.dart';
import 'package:your_app/app/config/network/dio_client.dart';
import 'package:your_app/app/config/network/api_constants.dart';

final dio = DioClient().dio;
final res = await dio.post(ApiConstants.login, data: {'email': 'a@b.c', 'pwd': 'x'});
```

**Local Storage Example:**

```dart
import 'package:your_app/app/config/local/shared_prefs.dart';

await SharedPrefs.instance.setString('token', 'abc123');
final token = await SharedPrefs.instance.getString('token');
```

### 2. Create a New Module

Generates a fully functional GetX module including:
- **Binding**: For dependency injection.
- **Controller**: For state management logic.
- **View**: For the UI (extends `GetView`).

It also automatically updates your route files unless specified otherwise.

**Command:**

```bash
flutter_getx_cli create <path/to/module>
```

**Example:**

Create a login module inside `auth`:

```bash
flutter_getx_cli create auth/login
```

**Output Structure:**

```
lib/app/
├── modules/
│   └── auth/
│       └── login/
│           ├── bindings/
│           │   └── login_binding.dart
│           ├── controllers/
│           │   └── login_controller.dart
│           └── views/
│               └── login_view.dart
└── routes/
    ├── app_pages.dart  <-- Updated with GetPage
    └── app_routes.dart <-- Updated with route constant
```

**Options:**

- `--no-route`: Generate the module files **without** adding entries to `app_routes.dart` and `app_pages.dart`. Useful for widgets or components that don't need a named route.

  ```bash
  flutter_getx_cli create components/user_card --no-route
  ```
  
**Routing Behavior & Safeguards:**
- Route constants are added to `app_routes.dart` only if not already present.
- `GetPage` entries are appended inside the `pages` list in `app_pages.dart`, preserving syntax.
- Duplicate detection prevents multiple entries when running the same command more than once.

### 3. Remove an Existing Module

Deletes the specified module directory and cleans up the associated routes.

**Command:**

```bash
flutter_getx_cli remove <path/to/module>
```

**Example:**

Remove the login module:

```bash
flutter_getx_cli remove auth/login
```

**What it does:**
1.  Deletes `lib/app/modules/auth/login`.
2.  Removes the route constant from `app_routes.dart`.
3.  Removes the `GetPage` entry and imports from `app_pages.dart`.

**Options:**

- `--routes-only`: **Only** remove the route entries from `app_routes.dart` and `app_pages.dart`. The module files (views, controllers, bindings) will remain untouched.

  ```bash
  flutter_getx_cli remove auth/login --routes-only
  ```

## 🧩 Executable
- After activation, the executable name is `flutter_getx_cli`.
- Examples:
  - `flutter_getx_cli init`
  - `flutter_getx_cli create auth/login`
  - `flutter_getx_cli remove auth/login`

## ❓ Troubleshooting

### Command not found

If you see `command not found: flutter_getx_cli` after installation, you need to add the Dart/Pub cache bin directory to your shell's PATH.

**Fix (macOS/Linux - bash/zsh):**

Add the following to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Then reload your shell:

```bash
source ~/.zshrc
```

**Fix (Windows - PowerShell):**

```powershell
# Make available in current session
$env:Path += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"

# Persist for future sessions
setx PATH "$env:Path;$env:USERPROFILE\AppData\Local\Pub\Cache\bin"
```

Restart PowerShell for changes to take effect.

**Fix (Windows - CMD):**

```cmd
setx PATH "%PATH%;%USERPROFILE%\AppData\Local\Pub\Cache\bin"
```

Close and reopen CMD.

**Fix (Linux - fish shell):**

```fish
set -Ux PATH $PATH $HOME/.pub-cache/bin
```

**Verify:**

```bash
which flutter_getx_cli   # macOS/Linux
where flutter_getx_cli   # Windows
```

---

*Built with ❤️ for the Flutter Community.*
