import 'package:base/utils/colors.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends Scaffold {
  const BaseScaffold({
    Key? key,
    PreferredSizeWidget? appBar,
    Color? backgroundColor,
    Widget? body,
  }) : super(
          key: key,
          appBar: appBar,
          backgroundColor: AppColors.background,
          body: body,
        );
}
