import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../utils/platform_layout.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/leaderboard')) return 1;
    if (location.startsWith('/course')) return 2;
    if (location.startsWith('/tutor')) return 3;
    if (location.startsWith('/profile') ||
        location.startsWith('/progress') ||
        location.startsWith('/certificates') ||
        location.startsWith('/dojos')) return 4;
    return 0;
  }

  void _go(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/leaderboard');
      case 2:
        context.go('/course');
      case 3:
        context.go('/tutor');
      case 4:
        context.go('/profile');
    }
  }

  static const _destinations = [
    (Icons.home_outlined, Icons.home, 'Learn'),
    (Icons.emoji_events_outlined, Icons.emoji_events, 'Leagues'),
    (Icons.map_outlined, Icons.map, 'Path'),
    (Icons.pets_outlined, Icons.pets, 'Sensei'),
    (Icons.person_outline, Icons.person, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);
    final isCompact = PlatformLayout.isCompact(context);
    final isWide = PlatformLayout.isWide(context);
    final isDesktop = PlatformLayout.isDesktop(context);

    final content = PlatformLayout.centeredContent(
      context: context,
      child: child,
    );

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.pets,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            AppConstants.appName,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _destinations.length,
                        itemBuilder: (context, i) {
                          final d = _destinations[i];
                          final isSelected = i == index;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Material(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                onTap: () => _go(context, i),
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected ? d.$2 : d.$1,
                                        color: isSelected
                                            ? AppColors.primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.7),
                                        size: 28,
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        d.$3,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? AppColors.primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: content),
          ],
        ),
      );
    }

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: index,
              onDestinationSelected: (i) => _go(context, i),
              labelType: NavigationRailLabelType.all,
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedIconTheme: const IconThemeData(color: AppColors.primary),
              minWidth: 72,
              minExtendedWidth: 200,
              leading: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Icon(
                  Icons.pets,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              destinations: _destinations
                  .map(
                    (d) => NavigationRailDestination(
                      icon: Icon(d.$1, size: 28),
                      selectedIcon: Icon(d.$2, color: AppColors.primary, size: 28),
                      label: Text(d.$3),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => _go(context, i),
        height: 80,
        elevation: 8,
        destinations: _destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.$1, size: 28),
                selectedIcon: Icon(d.$2, color: AppColors.primary, size: 28),
                label: d.$3,
              ),
            )
            .toList(),
      ),
    );
  }
}
