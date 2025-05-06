import 'package:chat_app/features/chat/views/mobile/conservation_chat_view.dart';
import 'package:chat_app/features/friend/friend_main_view.dart';
import 'package:chat_app/features/group/group_main_view.dart';
import 'package:chat_app/router/shell_route/bloc/shell_route_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:chat_app/router/routes.dart';

const destinations = [
  NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
  NavigationDestination(
      icon: Icon(Icons.people), label: 'Friends'),
  NavigationDestination(icon: Icon(Icons.group), label: 'Groups'),
];

const navigationRailDestinations = [
  NavigationRailDestination(
      icon: Icon(Icons.chat), label: Text('Chat')),
  NavigationRailDestination(
      icon: Icon(Icons.people), label: Text('Friends')),
  NavigationRailDestination(
      icon: Icon(Icons.group), label: Text('Groups')),
];

final shellRoute = ShellRoute(
  //navigatorKey: navigatorKey,
  builder: (context, state, child) {
    return BlocBuilder<ShellRouteCubit, int>(
      builder: (context, state) {
        final currentIndex = state;
        final cubit = context.read<ShellRouteCubit>();

        return LayoutBuilder(builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 600;

          void onDestinationSelected(int index) {
            cubit.setIndex(index);
            switch (index) {
              case 0:
                context.go(Routes.conversation);
                break;
              case 1:
                context.go(Routes.friends);
                break;
              case 2:
                context.go(Routes.groups);
                break;
            }
          }

          return Scaffold(
            body: isLargeScreen
                ? Row(
                    children: [
                      NavigationRail(
                        selectedIndex: currentIndex,
                        onDestinationSelected: onDestinationSelected,
                        destinations: navigationRailDestinations,
                        labelType: NavigationRailLabelType.all,
                        groupAlignment: -0.8,
                      ),
                      Expanded(child: child),
                    ],
                  )
                : child,
            bottomNavigationBar: isLargeScreen
                ? null
                : NavigationBar(
                    selectedIndex: currentIndex,
                    onDestinationSelected: onDestinationSelected,
                    destinations: destinations,
                  ),
          );
        });
      },
    );
  },
  routes: [
    GoRoute(
      path: Routes.conversation,
      builder: (context, state) => const ConversationListScreen(),
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: ConversationListScreen()),
    ),
    GoRoute(
      path: Routes.friends,
      builder: (context, state) => const FriendMainView(),
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: FriendMainView()),
    ),
    GoRoute(
      path: Routes.groups,
      builder: (context, state) => const GroupMainView(),
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: GroupMainView()),
    ),
  ],
);
