import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mod/core/extensions/context_extensions.dart';
import 'package:mod/core/l10n/l10n.dart';
import 'package:mod/core/theme/app_spacing.dart';
import 'package:mod/core/utils/validators.dart';
import 'package:mod/core/widgets/widgets.dart';
import 'package:mod/features/auth/presentation/login/cubit/login_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, this.showDemoHint = false});

  /// Credentials of the public dummyjson.com demo backend.
  static const demoUsername = 'emilys';
  static const demoPassword = 'emilyspass';
  static const minPasswordLength = 6;

  final bool showDemoHint;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.hideKeyboard();
    context.read<LoginCubit>().submit(
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLoading = context.select(
      (LoginCubit cubit) => cubit.state is LoginLoading,
    );

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.loginTitle,
                    style: context.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.loginSubtitle,
                    style: context.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppTextField(
                    key: const Key('login_username'),
                    controller: _usernameController,
                    label: l10n.usernameLabel,
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    enabled: !isLoading,
                    validator: Validators.required(l10n.usernameRequired),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    key: const Key('login_password'),
                    controller: _passwordController,
                    label: l10n.passwordLabel,
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    enabled: !isLoading,
                    onSubmitted: (_) => _submit(),
                    validator: Validators.minLength(
                      LoginForm.minPasswordLength,
                      l10n.passwordTooShort(LoginForm.minPasswordLength),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    key: const Key('login_submit'),
                    label: l10n.loginButton,
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                  if (widget.showDemoHint) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.demoAccountHint(
                        LoginForm.demoUsername,
                        LoginForm.demoPassword,
                      ),
                      style: context.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
