# Flutter GetX CLI

**Accelerate your Flutter development with the ultimate CLI for the GetX pattern.**

`flutter_getx_cli` is a powerful command-line tool designed to automate the creation of GetX modules, routes, and pages. It adheres to a clean architecture, ensuring your project structure remains scalable and maintainable.

## 🚀 Features

- **Automated Module Generation**: Create Controllers, Bindings, and Views in one go.
- **Smart Routing**: Automatically injects new routes into `app_routes.dart` and `app_pages.dart`.
- **Clean Architecture**: Enforces a standard folder structure (`lib/app/modules/...`).
- **Flexible Management**: Easily remove modules and their associated routes.
- **Customizable**: Options to skip route generation or only remove routes.

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

### 1. Create a New Module

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

### 2. Remove an Existing Module

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

## ❓ Troubleshooting

### Command not found

If you see `command not found: flutter_getx_cli` after installation, you need to add the Dart/Pub cache bin directory to your shell's PATH.

**Fix:**

Add the following to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Then reload your shell:

```bash
source ~/.zshrc
```

---

*Built with ❤️ for the Flutter Community.*
