import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Responsive layout — mobile bottom nav, web/desktop sidebar + max width.
class PlatformLayout {
  PlatformLayout._();

  static bool get isWeb => kIsWeb;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 800;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1100;

  static double maxContentWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1400) return 1080;
    if (w >= 900) return 840;
    return w;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1100) return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    if (w >= 600) return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  }

  static double contentWidth(BuildContext context) {
    final maxWidth = maxContentWidth(context);
    final horizontalPadding = pagePadding(context).horizontal;
    return (maxWidth - horizontalPadding).clamp(0, double.infinity);
  }

  static Widget centeredContent({
    required BuildContext context,
    required Widget child,
    EdgeInsets? padding,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: contentWidth(context)),
        child: Padding(
          padding: padding ?? pagePadding(context),
          child: child,
        ),
      ),
    );
  }

  /// Wrap page content for web — centered column on large screens.
  static Widget adaptiveScaffold({
    required BuildContext context,
    required Widget body,
  }) {
    if (!isWide(context)) return body;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth(context)),
        child: body,
      ),
    );
  }
}
