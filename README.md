# flutter_getx_cli

A command-line tool to speed up your GetX development workflow in Flutter.

## Installation

```bash
dart pub global activate flutter_getx_cli
```

## Usage

### Create a new module

```bash
flutter_getx_cli create <module_path>
```

This will create a new module with a view, controller, and binding. It will also automatically inject the route into your `app_pages.dart` and `app_routes.dart` files.

**Example:**

```bash
flutter_getx_cli create auth/login
```

### Generated Folder Structure

The command above will generate the following folder structure:

```
lib
└── app
    ├── modules
    │   └── auth
    │       └── login
    │           ├── bindings
    │           │   └── login_binding.dart
    │           ├── controllers
    │           │   └── login_controller.dart
    │           └── views
    │               └── login_view.dart
    └── routes
        ├── app_pages.dart
        └── app_routes.dart
```

It will also add a new route to `lib/app/routes/app_routes.dart` and a new `GetPage` to `lib/app/routes/app_pages.dart`.

**Options:**

*   `--no-route`: Create the module without adding a route.

### Remove a module

```bash
flutter_getx_cli remove <module_path>
```

This will remove the module directory and its associated routes.

**Options:**

*   `--routes-only`: Only remove the routes, leaving the module files intact.

## Troubleshooting

**`command not found: flutter_getx_cli`**

If you see this error after installation, it means the directory where `pub` installs global packages is not in your system's `PATH`.

You can fix this by adding the following line to your shell's configuration file (usually `~/.zshrc`, `~/.bashrc`, or `~/.bash_profile`):

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

After adding this line, restart your terminal or run `source ~/.zshrc` (or the equivalent for your shell) to apply the changes.
