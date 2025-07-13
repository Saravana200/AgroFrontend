import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kang/router.dart';

@RoutePage()
class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key});

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        MapCoordinatesSelectorRoute(),
        ProfileRoute()
      ],
      builder: (context, child) {
        final tabRouter = AutoTabsRouter.of(context);
        return Scaffold(
            body: tabRouter.activeIndex != 1
                ? GestureDetector(
                    child: child,
                    onHorizontalDragEnd: (details) {
                      int activeIndex = tabRouter.activeIndex;
                      if (details.primaryVelocity != 0) {
                        if (details.primaryVelocity! > 0 && activeIndex > 0) {
                          tabRouter.setActiveIndex(activeIndex - 1);
                        } else if (details.primaryVelocity! < 0 &&
                            activeIndex < 2) {
                          tabRouter.setActiveIndex(activeIndex + 1);
                        }
                      }
                    },
                  )
                : child,
            bottomNavigationBar: NavigationBar(
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              onDestinationSelected: tabRouter.setActiveIndex,
              selectedIndex: tabRouter.activeIndex,
              indicatorColor: theme.colorScheme.secondaryContainer,
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.agriculture), label: "home"),
                NavigationDestination(
                    icon: Icon(Icons.travel_explore_rounded), label: "search"),
                NavigationDestination(
                    icon: Icon(Icons.person), label: "profile"),
              ],
            ));
      },
    );
  }
}
