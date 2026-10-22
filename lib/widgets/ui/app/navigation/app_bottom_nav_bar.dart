import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:devant_components/extensions/context_extension.dart';
import 'package:devant_components/app_platform.dart';

import '../../../../theme/theme_constants.dart';

// /// A single destination in [AppBottomNavBar].
// class AppBottomNavItem {
//   const AppBottomNavItem({
//     required this.label,
//     required this.icon,
//     this.activeIcon,
//   });

//   final String label;
//   final IconData icon;
//   final IconData? activeIcon;
// }

// /// Adaptive bottom navigation bar.

// class AppBottomNavBar extends StatelessWidget {
//   const AppBottomNavBar({
//     super.key,
//     required this.items,
//     required this.currentIndex,
//     required this.onTap,
//     this.platform,
//   });

//   final List<AppBottomNavItem> items;
//   final int currentIndex;
//   final ValueChanged<int> onTap;
//   final AppPlatformStyle? platform;

//   @override
//   Widget build(BuildContext context) {
//     final useCupertino = platform != null
//         ? platform == AppPlatformStyle.cupertino
//         : context.isCupertinoUi;
//     final colors = context.colors;

//     if (useCupertino) {
//       return CupertinoTabBar(
//         currentIndex: currentIndex,
//         onTap: onTap,
//         backgroundColor: colors.surfaceContainer,
//         activeColor: colors.primary,
//         inactiveColor: colors.onSurfaceVariant,
//         items: [
//           for (final item in items)
//             BottomNavigationBarItem(
//               icon: Icon(item.icon),
//               activeIcon: Icon(item.activeIcon ?? item.icon),
//               label: item.label,
//             ),
//         ],
//       );
//     }

//     return NavigationBar(
//       selectedIndex: currentIndex,
//       onDestinationSelected: onTap,
//       backgroundColor: colors.surfaceContainer,
//       indicatorColor: colors.secondaryContainer,
//       destinations: [
//         for (final item in items)
//           NavigationDestination(
//             icon: Icon(item.icon),
//             selectedIcon: Icon(item.activeIcon ?? item.icon),
//             label: item.label,
//           ),
//       ],
//     );
//   }
// }


/// A single destination in [AppBottomNavBar].
class AppBottomNavItem {
  const AppBottomNavItem({
    required this.label,
    required this.icon,
    this.isHighlighted = false,
  });

  final String label;
  final IconData icon;

  /// Renders as the floating orb that rises above the bar.
  /// Intended for exactly one (centre) item.
  final bool isHighlighted;
}

/// Bottom navigation bar with an optional floating, highlighted centre item.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double _barHeight = 64;
  static const double _orbSize = 62;
  static const double _orbRing = 4;

  static const double _overhang = 26;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: _overhang + _barHeight + bottomInset,
      child: Stack(
        children: [
          // Bar surface.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _barHeight + bottomInset + 10,
            child:  DecoratedBox(
              decoration: BoxDecoration(
                color: AppBrandColors.onCta,
              ),
            ),
          ),
          // Items.
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomInset,
            height: _barHeight,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: items[i].isHighlighted
                        ? _OrbItem(
                            item: items[i],
                            selected: i == currentIndex,
                            onTap: () => onTap(i),
                          )
                        : _NavItem(
                            item: items[i],
                            selected: i == currentIndex,
                            onTap: () => onTap(i),
                          ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.primary : colors.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: ExcludeSemantics(
        child: InkResponse(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          radius: 36,
          highlightShape: BoxShape.circle,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 26,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrbItem extends StatelessWidget {
   _OrbItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  final _glow = AppBrandColors.link;
  static final _orbGradient = RadialGradient(
    center: Alignment(0, -0.35),
    radius: 0.95,
    colors: AppBrandColors.backgroundFallback,
    stops: [0.0, 0.55, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labelColor = selected ? colors.primary : colors.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Orb rises above the bar (parent Stack reserves the overhang).
              Positioned(
                top: -(AppBottomNavBar._orbSize / 2) + 4,
                child: AnimatedScale(
                  scale: selected ? 1.06 : 1,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: Container(
                    width: AppBottomNavBar._orbSize,
                    height: AppBottomNavBar._orbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: _glow.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(AppBottomNavBar._orbRing),
                    child:  DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _orbGradient,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: labelColor,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
