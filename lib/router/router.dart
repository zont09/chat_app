import 'package:chat_app/features/login/login_main_view.dart';
import 'package:chat_app/services/navigator_service.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: Routes.login,
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginMainView(),
    ),

    // Cách dùng goroute:
    // context.go(Routes.login);
    // context.push(Routes.login, extra: {
    //   'email': email,
    //   'password': password,
    // });
    // ..

    // tham khảo
    // shellRoute,
    // GoRoute(
    //   path: Routes.splash,
    //   builder: (context, state) => const SplashScreen(),
    // ),
    // GoRoute(
    //   path: Routes.login,
    //   builder: (context, state) {
    //     final extraData = state.extra as Map<String, String>?;
    //     return LoginScreen(
    //       email: extraData?['email'],
    //       password: extraData?['password'],
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: Routes.register,
    //   builder: (context, state) {
    //     final extraData = state.extra as Map<String, dynamic>?;
    //     return RegisterScreen(
    //       email: extraData?['email'],
    //       password: extraData?['password'],
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: Routes.editProfile,
    //   builder: (context, state) => const EditProfileScreen(),
    // ),
    // GoRoute(
    //   path: Routes.eventDetail,
    //   builder: (context, state) {
    //     final eventId = state.pathParameters['eventId']!;
    //     final canEdit = state.extra as bool?;
    //     return EventDetailScreen(eventId: eventId, canEdit: canEdit ?? false);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.createEvent,
    //   builder: (context, state) => const AddEventScreen(),
    // ),
    // GoRoute(
    //   path: Routes.editEvent,
    //   builder: (context, state) {
    //     final event = state.extra as Event;
    //     return EditEventScreen(event: event);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.eventList,
    //   builder: (context, state) => EventListScreen(
    //     title: state.uri.queryParameters['title'] ?? 'Events',
    //     sortBy: state.uri.queryParameters['sortBy'] ?? 'date',
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.eventParticipants,
    //   builder: (context, state) {
    //     final event = state.extra as Event;
    //     return ParticipantScreen(event: event);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.ticketDetail,
    //   builder: (context, state) {
    //     final ticketId = state.pathParameters['ticketId']!;
    //     return TicketDetailScreen(ticketId: ticketId);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.transferTicketSearch,
    //   builder: (context, state) {
    //     final ticket = state.extra as Ticket?;
    //     return TransferTicketSearchScreen(ticket: ticket);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.transferTicket,
    //   builder: (context, state) => const TransferTicketScreen(),
    // ),
    // GoRoute(
    //   path: Routes.forumDetail,
    //   builder: (context, state) {
    //     final forumId = state.pathParameters['forumId']!;
    //     final conversasion = state.extra as Conversasion?;
    //     return ForumDetailScreen(forumId: forumId, conversasion: conversasion);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.notification,
    //   builder: (context, state) => const NotificationScreen(),
    // ),
    // GoRoute(
    //   path: Routes.searchEvent,
    //   builder: (context, state) => const SearchEventScreen(),
    // ),
    // GoRoute(
    //   path: Routes.accountManagement,
    //   builder: (context, state) {
    //     return const AccountManagementScreen();
    //   },
    // ),
    // GoRoute(
    //   path: Routes.universityManagement,
    //   builder: (context, state) => const UniversityManagementScreen(),
    // ),
    // GoRoute(
    //   path: Routes.facultyManagement,
    //   builder: (context, state) {
    //     final university = state.extra as University;
    //     return FacultyManagementScreen(university: university);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.majorManagement,
    //   builder: (context, state) {
    //     final faculty = state.extra as Faculty;
    //     return MajorManagementScreen(faculty: faculty);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.eventManagementFullScreen,
    //   builder: (context, state) => const EventManagementScreen(),
    // ),
    // GoRoute(
    //   path: Routes.report,
    //   builder: (context, state) => const ReportScreen(),
    // ),
    // GoRoute(
    //   path: Routes.reportEvent,
    //   builder: (context, state) {
    //     final event = state.extra as Event;
    //     return ReportEventScreen(event: event);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.forgotPassword,
    //   builder: (context, state) => const ForgotPasswordScreen(),
    // ),
  ],
);
