import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'presentation/screens/auth/lock_screen.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/monthly_cycle/monthly_cycle_screen.dart';
import 'presentation/screens/fer/fer_detail_screen.dart';
import 'presentation/providers/auth_provider.dart';

import 'core/di/injection.dart';

import 'package:intl/date_symbol_data_local.dart';

// Imports needed for the new routes
import 'presentation/widgets/main_wrapper.dart';
import 'presentation/screens/wallet/wallet_screen.dart';
import 'presentation/screens/analysis/analysis_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/msp/msp_management_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await initializeDateFormatting('pt_BR', null);
  configureDependencies();
  runApp(
    RestartWidget(
      child: const ProviderScope(child: GradusApp()),
    ),
  );
}



final _routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  
  // Define the Global Key for navigator to allow pushing full screen if needed
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    refreshListenable: ValueNotifier(authState),
    
    redirect: (context, state) {
      final authStatus = authState.value;
      if (authStatus == null || authState.isLoading) return null;

      final isLoggingIn = state.uri.toString() == '/login';
      final isOnboarding = state.uri.toString() == '/onboarding';

      if (authStatus == AuthStatus.unauthenticated) {
        return isOnboarding ? null : '/onboarding';
      }

      if (authStatus == AuthStatus.locked) {
        return isLoggingIn ? null : '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        // If try to go to login/onboard, send to home
        if (isLoggingIn || isOnboarding) return '/';
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LockScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Persistent Bottom Bar Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard (Home)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const DashboardScreen(), // This will need to be stripped of its own Scaffold
                routes: [
                  GoRoute(
                    path: 'fer-detail',
                    builder: (context, state) => const FerDetailScreen(),
                  ),
                  GoRoute(
                    path: 'msp-management',
                    builder: (context, state) => const MspManagementScreen(),
                  ),
                  GoRoute(
                    path: 'monthly-cycle',
                    builder: (context, state) => const MonthlyCycleScreen(),
                  ),
                ]
              ),
            ],
          ),
          
          // Branch 1: Wallet
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                builder: (context, state) => const WalletScreen(),
              ),
            ],
          ),
          
          // Branch 2: Analysis
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/analysis',
                builder: (context, state) => const AnalysisScreen(),
              ),
            ],
          ),
          
          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({super.key, required this.child});

  static Future<void> restartApp(BuildContext context) async {
    final state = context.findAncestorStateOfType<_RestartWidgetState>();
    await state?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  Future<void> restartApp() async {
    // 1. Reset Dependency Injection (closes DB, Disposes Singletons)
    await getIt.reset();
    
    // 2. Re-configure Dependencies (New DB Connection)
    configureDependencies();

    // 3. Rebuild App Tree
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class GradusApp extends ConsumerWidget {
  const GradusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provide a new ProviderScope for each restart
    // Wait, ProviderScope is in main(), above GradusApp. 
    // If we restart GradusApp, we are INSIDE ProviderScope.
    // To fully reset Riverpod, we need to be OUTSIDE or pass a child to ProviderScope?
    // Actually, RestartWidget should be the TOPMOST widget, wrapping ProviderScope.
    return MaterialApp.router(
      title: 'Gradus',
      theme: AppTheme.darkTheme,
      routerConfig: ref.watch(_routerProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
