## 1.0.7

- **Feat**: `init` now creates `core/config/api_config.dart` with a dummy API call.
- **Feat**: added dependency injection using getIt for api service and dio client
- **Docs**: README updated with Services section and usage example.


## 1.0.6

- **Feat**: `init` now creates `services/data/api_service.dart` with a dummy API call.
- **Docs**: README updated with Services section and usage example.

## 1.0.5

- **Feat**: Extended `init` to generate `config/network` (Dio client, API constants, `auth` and `logger` interceptors).
- **Feat**: Added `config/local/shared_prefs.dart` with typed and object helpers (JSON).
- **Feat**: Added `core/constants` (`app_constants.dart`, `string_constants.dart`, `global_constants.dart`).
- **Feat**: Added `core/utils/dialog_utils.dart` for alerts, confirmations, and loading dialogs.
- **Chore**: `init` ensures dependencies: `dio`, `get`, `shared_preferences`.
- **Fix**: Stabilized `GetPage` injection to append inside list and prevent duplicates.
- **Docs**: Overhauled README for pub.dev with initialization, routing, config, and examples.

## 1.0.4

- **Feat**: Added `init` command to bootstrap project with `core` directory (components, theme, utils).
- **Feat**: Included standard UI components (`PrimaryButton`, `PrimaryTextField`, `PrimaryDropdown`).
- **Feat**: Included pre-configured `AppTheme`, `AppColors`, and `AppTextStyles`.
- **Feat**: Included `AppUtils` with extensive wrappers for common `GetUtils` functions.


## 1.0.3

- **Fix**: Prevented duplicate route constants and `GetPage` entries when running `create` multiple times.
- **Fix**: Added check to prevent overwriting existing module directories.
- **Fix**: Corrected regex logic for injecting routes into `app_pages.dart` to prevent syntax errors.
- **Fix**: Improved `remove` command to clean up bindings and view imports from `app_pages.dart`.
- **Docs**: Comprehensive update to README.md with detailed usage examples and folder structure.
- **Feat**: Added `--no-route` flag to `create` command.
- **Feat**: Added `--routes-only` flag to `remove` command.

## 1.0.2

- Initial stable release with basic module creation and removal.

## 1.0.0

- Initial version.
