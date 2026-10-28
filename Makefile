FLAVOR ?= dev
FLUTTER ?= flutter
DART ?= dart

.PHONY: help setup get gen watch l10n format format-check analyze test coverage check run build-apk build-ipa clean

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

setup: get l10n gen ## First-time setup: deps + localizations + code generation

get: ## Install dependencies
	$(FLUTTER) pub get

gen: ## Run build_runner once (freezed, json, retrofit, injectable)
	$(DART) run build_runner build

watch: ## Run build_runner in watch mode
	$(DART) run build_runner watch

l10n: ## Generate localizations from lib/l10n/arb
	$(FLUTTER) gen-l10n

format: ## Format all Dart sources
	$(DART) format lib test

format-check: ## Fail when sources are not formatted
	$(DART) format --output=none --set-exit-if-changed lib test

analyze: ## Static analysis
	$(FLUTTER) analyze

test: ## Run all tests
	$(FLUTTER) test

coverage: ## Run tests with coverage (generated files excluded)
	$(FLUTTER) test --coverage
	@if command -v lcov >/dev/null; then \
		lcov --ignore-errors unused --remove coverage/lcov.info '**/*.g.dart' '**/*.freezed.dart' '**/*.config.dart' 'lib/l10n/gen/*' -o coverage/lcov.info >/dev/null; \
		genhtml coverage/lcov.info -o coverage/html >/dev/null && echo "Report: coverage/html/index.html"; \
	fi

check: format-check analyze test ## Everything CI runs

run: ## Run app: make run FLAVOR=dev|stg|prod
	$(FLUTTER) run --flavor $(FLAVOR) --dart-define-from-file=config/$(FLAVOR).json

build-apk: ## Build release APK: make build-apk FLAVOR=prod
	$(FLUTTER) build apk --flavor $(FLAVOR) --dart-define-from-file=config/$(FLAVOR).json --release

build-ipa: ## Build release IPA: make build-ipa FLAVOR=prod
	$(FLUTTER) build ipa --flavor $(FLAVOR) --dart-define-from-file=config/$(FLAVOR).json --release

clean: ## Clean build outputs
	$(FLUTTER) clean
