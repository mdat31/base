# Mod — Flutter Base Project

Base project để khởi tạo app Flutter mới: **Clean Architecture (feature-first)**, **BLoC**, **injectable DI**,
**3 flavors**, **đa ngôn ngữ**, **common widgets / design tokens**, và bộ test đầy đủ (unit, bloc, widget, architecture).

App demo chạy thật với backend công khai [dummyjson.com](https://dummyjson.com):
đăng nhập → trang chủ (profile) → cài đặt (theme, ngôn ngữ, đăng xuất). Tài khoản demo: `emilys` / `emilyspass`.

## Mục lục

- [Yêu cầu](#yêu-cầu)
- [Bắt đầu nhanh](#bắt-đầu-nhanh)
- [Flavors & cấu hình môi trường](#flavors--cấu-hình-môi-trường)
- [Tech stack](#tech-stack)
- [Cấu trúc thư mục](#cấu-trúc-thư-mục)
- [Kiến trúc](#kiến-trúc)
- [Thêm một feature mới](#thêm-một-feature-mới)
- [Networking & xử lý lỗi](#networking--xử-lý-lỗi)
- [Localization](#localization)
- [Theme & common widgets](#theme--common-widgets)
- [Testing](#testing)
- [CI & lệnh hay dùng](#ci--lệnh-hay-dùng)
- [Gợi ý mở rộng](#gợi-ý-mở-rộng)

## Yêu cầu

| Tool | Version |
| --- | --- |
| Flutter | `>= 3.47.0` (stable) |
| Dart | `^3.13.0` |
| Android | AGP 9.1 · Kotlin 2.4 · Gradle 9.3 · Java 17 |
| iOS | 15.0+ · Xcode mới nhất |

Khuyến nghị dùng [FVM](https://fvm.app) để cố định version Flutter cho cả team.

## Bắt đầu nhanh

```bash
make setup          # pub get + gen-l10n + build_runner
make run            # chạy flavor dev (mặc định)
make run FLAVOR=stg # chạy flavor khác
```

Không có `make`:

```bash
flutter pub get
dart run build_runner build
flutter run --flavor dev --dart-define-from-file=config/dev.json
```

> File sinh ra (`*.g.dart`, `*.freezed.dart`, `injection.config.dart`, `lib/l10n/gen/`) **không commit**.
> Sau khi pull hoặc sửa model/annotation, chạy lại `make gen` (hoặc `make watch` khi đang dev).

VS Code: đã có sẵn 3 launch config `dev` / `stg` / `prod` trong `.vscode/launch.json`.

## Flavors & cấu hình môi trường

| Flavor | Android applicationId | iOS bundle id | Tên app | Config |
| --- | --- | --- | --- | --- |
| `dev` | `com.vmo.mod.dev` | `com.vmo.mod.dev` | Mod Dev | `config/dev.json` |
| `stg` | `com.vmo.mod.stg` | `com.vmo.mod.stg` | Mod Stg | `config/stg.json` |
| `prod` | `com.vmo.mod` | `com.vmo.mod` | Mod | `config/prod.json` |

- **Một entry point duy nhất** `lib/main.dart`. Giá trị theo môi trường truyền qua `--dart-define-from-file`
  và được đọc tập trung trong [`AppConfig`](lib/core/config/app_config.dart).
- Native: Android khai báo `productFlavors` trong [`android/app/build.gradle.kts`](android/app/build.gradle.kts);
  iOS dùng scheme `dev`/`stg`/`prod` + `ios/Flutter/<flavor><BuildMode>.xcconfig`.
- Thêm biến môi trường mới: thêm key vào cả 3 file `config/*.json` → thêm field + key trong `AppConfig` → test trong
  `test/core/config/app_config_test.dart`.

> ⚠️ **Không đặt secret** (API key, signing key...) trong `config/*.json`: dart-define có thể đọc được từ binary.
> Dùng CI secrets hoặc backend để cấp phát.

## Tech stack

| Mục đích | Package |
| --- | --- |
| State management | `flutter_bloc`, `bloc` |
| Dependency injection | `get_it` + `injectable` |
| Navigation | `go_router` (redirect theo auth, `StatefulShellRoute` cho bottom nav) |
| Networking | `dio` + `retrofit`, `pretty_dio_logger` (chỉ bật khi `ENABLE_LOGGING=true`) |
| Model / immutability | `freezed` (entity, state, failure), `json_serializable` (DTO) |
| Kết quả / lỗi | `fpdart` (`Either<Failure, T>` qua typedef `Result<T>`) |
| Lưu trữ | `flutter_secure_storage` (token), `shared_preferences` (settings) |
| Localization | `flutter_localizations` + `intl` (ARB) |
| Testing | `flutter_test`, `bloc_test`, `mocktail` |
| Lint | `flutter_lints` + rule chặt hơn (`strict-casts`, `strict-inference`, `strict-raw-types`) |

## Cấu trúc thư mục

```text
lib/
├── main.dart                 # entry point duy nhất
├── bootstrap.dart            # init binding, config, error handlers, DI, BlocObserver
├── app/                      # composition root: nơi DUY NHẤT được dùng getIt
│   ├── app.dart              # MaterialApp.router, theme/locale theo SettingsCubit
│   ├── di/injection.dart     # configureDependencies() (+ injection.config.dart sinh ra)
│   ├── router/               # GoRouter, routes, redirect thuần (test được), bottom-nav shell
│   └── splash_screen.dart
├── core/                     # dùng chung cho ≥ 2 feature, KHÔNG import features/
│   ├── config/               # Flavor, AppConfig
│   ├── di/                   # RegisterModule (Dio, SharedPreferences, SecureStorage), DiKeys
│   ├── error/                # AppException (data), Failure (domain), Result, runGuarded
│   ├── extensions/           # BuildContext extensions
│   ├── l10n/                 # context.l10n, Failure → message đã dịch
│   ├── logging/              # AppLogger, AppBlocObserver
│   ├── network/              # DioFactory, AuthInterceptor (refresh token), mapper lỗi
│   ├── storage/              # TokenStorage (secure), KeyValueStorage (prefs)
│   ├── theme/                # AppColors, AppSpacing, AppRadius, AppTheme (light/dark)
│   ├── usecase/              # UseCase, StreamUseCase, NoParams
│   ├── utils/                # Validators
│   └── widgets/              # AppButton, AppTextField, AppErrorView, AppEmptyView, ...
├── features/
│   ├── auth/                 # login, logout, session, refresh token
│   │   ├── data/             # api/ (Retrofit) · datasources/ · models/ (DTO) · repositories/ · services/
│   │   ├── domain/           # entities/ · repositories/ (contract) · usecases/
│   │   └── presentation/     # bloc/ (AuthBloc toàn app) · login/{cubit,screens,widgets}
│   ├── home/presentation/    # profile người dùng (dùng domain của auth)
│   └── settings/             # theme + ngôn ngữ, lưu bằng KeyValueStorage
└── l10n/arb/                 # app_en.arb (template), app_vi.arb, app_ja.arb

test/                         # mirror lib/
├── architecture/             # test chặn vi phạm dependency rule
├── helpers/                  # pumpApp(), fixtures, l10nEn
└── ...
```

## Kiến trúc

```text
UI (Screen/Widget) ──event──▶ Bloc/Cubit ──▶ UseCase ──▶ Repository (contract, domain)
                                                              ▲
                                     RepositoryImpl (data) ───┘──▶ DataSource ──▶ Retrofit API / Storage
```

**Dependency rule** — `presentation → domain ← data`. Được kiểm tra tự động bởi
[`test/architecture/layer_boundaries_test.dart`](test/architecture/layer_boundaries_test.dart):

- `domain/` là **Dart thuần**: không import `flutter`, `dio`, `data/`, `presentation/`.
- `data/` không import `presentation/` hay widget.
- `presentation/` không import `data/`, `get_it`, `dio`, hay DI. Dependency đi qua constructor.
- Không feature nào import `data/` của feature khác (được dùng `domain/` của nhau).
- `core/` không import `features/` hay `app/`.

**SOLID áp dụng thế nào**

- **S** — mỗi use case một hành động; datasource chỉ gọi API thô; repository chỉ điều phối + map lỗi.
- **O** — `DioFactory` nhận danh sách interceptor; thêm hành vi không cần sửa factory.
- **L / I** — contract nhỏ (`TokenStorage`, `KeyValueStorage`, `TokenRefresher`); mock được trong test.
- **D** — bloc phụ thuộc use case, use case phụ thuộc interface repository; impl bind bằng
  `@LazySingleton(as: Contract)`. `core/network` cần refresh token nhưng chỉ biết interface `TokenRefresher`;
  feature `auth` cung cấp implementation.

**Quy ước đặt tên**: file = tên class dạng snake_case · `XScreen` · `XBloc`/`XCubit` + `XState` · `XApi` ·
`XRemoteDataSource` · `XRepository` + `XRepositoryImpl` · `VerbNounUseCase` · `XRequest`/`XResponse` (DTO) · `XEntity`.

## Thêm một feature mới

Làm theo TDD — viết test trước cho từng lớp, chạy đỏ, rồi implement cho xanh.

1. **Domain** — `lib/features/<feature>/domain/`
   - `entities/` (freezed), `repositories/<x>_repository.dart` (`abstract interface class`),
     `usecases/<verb_noun>_use_case.dart` (`implements UseCase<T, Params>`, `@lazySingleton`).
   - Test use case với mock repository.
2. **Data** — `lib/features/<feature>/data/`
   - `models/` DTO `@JsonSerializable` + `toEntity()`; `api/` Retrofit `@RestApi`; đăng ký API trong một `@module`.
   - `datasources/` (`@LazySingleton(as: ...)`), `repositories/<x>_repository_impl.dart` bọc mọi call trong
     `runGuarded(...)` để trả `Result<T>`.
   - Test mapping DTO, datasource, repository (thành công + từng loại lỗi).
3. **Presentation** — `lib/features/<feature>/presentation/`
   - Cubit/Bloc (`@injectable`) với state freezed; screen chỉ đọc bloc từ context; tái sử dụng `core/widgets`.
   - Test bằng `blocTest` và widget test với `MockCubit` + `pumpApp`.
4. **Wiring** — thêm path vào `AppRoutes`, khai báo route + `BlocProvider(create: (_) => getIt<XCubit>())` trong
   `app/router/app_router.dart`.
5. **Strings** — thêm key vào `app_en.arb` (template) và bản dịch `app_vi.arb`, `app_ja.arb`.
6. `make gen && make check`.

## Networking & xử lý lỗi

- Hai Dio client: `Dio` chính (có `AuthInterceptor`) và `@Named(DiKeys.plainDio)` (không auth, dùng cho refresh + retry).
- `AuthInterceptor` (`QueuedInterceptor`):
  - Gắn `Authorization: Bearer <token>` cho mọi request, trừ endpoint đánh dấu `@Extra({AuthInterceptor.skipAuthKey: true})`.
  - Gặp `401` → refresh token **một lần** (request song song dùng chung token mới) → retry.
    Refresh thất bại → xoá token + `SessionExpiryNotifier` báo hết phiên → `AuthBloc` chuyển `unauthenticated`
    → router tự đưa về `/login`.
- Luồng lỗi: `DioException` → `AppException` (`mapDioException`) → `Failure` (`runGuarded`) →
  UI hiển thị `failure.localizedMessage(context.l10n)`.

## Localization

- ARB ở `lib/l10n/arb/`, template là `app_en.arb`; hiện hỗ trợ **en, vi, ja**.
- Dùng trong widget: `context.l10n.loginTitle`.
- Thêm ngôn ngữ: tạo `app_<code>.arb` (nhớ key `languageName`) → `flutter gen-l10n` (tự chạy khi `pub get`).
  Màn Settings tự liệt kê ngôn ngữ mới.
- Key chưa dịch được ghi vào `build/untranslated_messages.json`.

## Theme & common widgets

- Đổi màu thương hiệu: sửa `AppColors.seed` — toàn bộ `ColorScheme` light/dark sinh từ seed (Material 3).
- Khoảng cách/bo góc: `AppSpacing` (lưới 4pt), `AppRadius`. Không dùng số "magic".
- Widget dùng chung (`import 'package:mod/core/widgets/widgets.dart';`):

| Widget | Dùng cho |
| --- | --- |
| `AppButton` / `.secondary` / `.text` | Nút có trạng thái loading |
| `AppTextField` | Input có label, validator, toggle ẩn/hiện mật khẩu |
| `AppLoadingIndicator` | Loading giữa màn hình |
| `AppErrorView` / `AppEmptyView` / `AppMessageView` | Trạng thái lỗi (có retry) / rỗng |
| `context.showAppSnackBar(msg, type:)` | Snackbar info / success / error |
| `showAppConfirmDialog(...)` | Dialog xác nhận, trả `Future<bool>` |
| `AppAvatar` | Avatar mạng, fallback chữ cái đầu |

## Testing

```bash
make test       # chạy toàn bộ
make coverage   # coverage (loại file generated nếu có lcov) → coverage/html
```

| Loại | Ví dụ |
| --- | --- |
| Unit | `test/core/**`, use case, repository, DTO mapping |
| Bloc | `blocTest` cho `AuthBloc`, `LoginCubit`, `HomeCubit`, `SettingsCubit` |
| Widget | Login, Home, Settings, common widgets, bottom-nav shell |
| Architecture | `test/architecture/layer_boundaries_test.dart` |
| DI smoke | `test/app/di/injection_test.dart` — resolve toàn bộ graph thật |

Quy ước: `mocktail` (không codegen mock), assert chuỗi bằng `l10nEn.<key>` thay vì hard-code text,
helper `tester.pumpApp(widget)` để có sẵn theme + localization.

## CI & lệnh hay dùng

GitHub Actions ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)) chạy trên mọi PR:
`pub get → gen-l10n → build_runner → format check → analyze → test --coverage`.

```bash
make help         # liệt kê lệnh
make gen          # build_runner một lần
make watch        # build_runner watch
make format       # dart format
make analyze      # flutter analyze
make check        # format-check + analyze + test (giống CI)
make build-apk FLAVOR=prod
make build-ipa FLAVOR=prod
```

## Gợi ý mở rộng

Những thứ một base project thường có thêm, sắp theo mức độ nên làm sớm:

**Nên làm sớm**
- [ ] **Crash reporting**: Firebase Crashlytics hoặc Sentry — nối vào `AppLogger.error` và handler trong `bootstrap.dart`;
      Firebase tách project theo flavor.
- [ ] **Release signing**: `android/key.properties` + `signingConfigs`, iOS signing qua fastlane match.
- [ ] **CD**: fastlane / Codemagic build & upload theo flavor (Firebase App Distribution cho dev/stg, store cho prod).
- [ ] **App icon & splash theo flavor**: `flutter_launcher_icons`, `flutter_native_splash`.
- [ ] **Assets type-safe**: `flutter_gen` cho ảnh/font/màu.
- [ ] **Kiểm tra kết nối mạng**: `connectivity_plus` + banner offline.

**Khi app lớn dần**
- [ ] **Analytics** (Firebase Analytics) qua interface `AnalyticsService` trong `core/`.
- [ ] **Remote config / feature flags**, **force update** (so sánh version với backend).
- [ ] **Push notification** (FCM + `flutter_local_notifications`) và **deep link** (đã có `go_router`).
- [ ] **Offline cache / DB local**: `drift` hoặc `isar`, chiến lược cache-first trong repository.
- [ ] **Pagination**: `infinite_scroll_pagination` + `PagedState` dùng chung.
- [ ] **Form phức tạp**: `formz` cho validation trong cubit.
- [ ] **Golden test** (`alchemist`) và **integration test** (`patrol`) cho luồng chính.
- [ ] **Security**: SSL pinning, phát hiện root/jailbreak, `--obfuscate --split-debug-info` khi build release.
- [ ] **Hiển thị version app** (`package_info_plus`) ở Settings.
- [ ] **Monorepo** khi nhiều app dùng chung: tách `core` thành package (melos / pub workspaces).
- [ ] **Accessibility**: kiểm tra text scale, semantics label, contrast.
