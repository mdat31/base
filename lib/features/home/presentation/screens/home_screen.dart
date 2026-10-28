import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mod/core/l10n/l10n.dart';
import 'package:mod/core/theme/app_spacing.dart';
import 'package:mod/core/widgets/widgets.dart';
import 'package:mod/features/home/presentation/cubit/home_cubit.dart';
import 'package:mod/features/home/presentation/widgets/profile_card.dart';

/// Expects a [HomeCubit] above it (provided by the router).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navHome)),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => switch (state) {
          HomeLoading() => const AppLoadingIndicator(),
          HomeFailure(:final failure) => AppErrorView(
            message: failure.localizedMessage(context.l10n),
            onRetry: context.read<HomeCubit>().load,
          ),
          HomeLoaded(:final user) => RefreshIndicator(
            onRefresh: context.read<HomeCubit>().load,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [ProfileCard(user: user)],
            ),
          ),
        },
      ),
    );
  }
}
