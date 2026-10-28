import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mod/core/l10n/l10n.dart';
import 'package:mod/core/widgets/widgets.dart';
import 'package:mod/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:mod/features/auth/presentation/login/widgets/login_form.dart';

/// Expects a [LoginCubit] above it (provided by the router).
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, this.showDemoHint = false});

  final bool showDemoHint;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state case LoginFailure(:final failure)) {
          context.showAppSnackBar(
            failure.localizedMessage(context.l10n),
            type: AppSnackBarType.error,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(child: LoginForm(showDemoHint: showDemoHint)),
      ),
    );
  }
}
