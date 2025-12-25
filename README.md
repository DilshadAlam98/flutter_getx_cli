# getx_cli

A command-line tool to speed up your GetX development workflow.

## Installation

```bash
dart pub global activate getx_cli
```

## Usage

### Create a new module

```bash
getx_cli create <module_path>
```

This will create a new module with a view, controller, and binding. It will also automatically inject the route into your `app_pages.dart` and `app_routes.dart` files.

**Example:**

```bash
getx_cli create auth/login
```

This will create the following files:

*   `lib/app/modules/auth/login/views/login_view.dart`
*   `lib/app/modules/auth/login/controllers/login_controller.dart`
*   `lib/app/modules/auth/login/bindings/login_binding.dart`

It will also add a new route to `lib/app/routes/app_routes.dart` and a new `GetPage` to `lib/app/routes/app_pages.dart`.

**Options:**

*   `--no-route`: Create the module without adding a route.

### Remove a module

```bash
getx_cli remove <module_path>
```

This will remove the module and its associated routes.

**Options:**

*   `--routes-only`: Only remove the routes, leaving the module files intact.
