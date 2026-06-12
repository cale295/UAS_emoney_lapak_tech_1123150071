class AppRouter {
    static final _rootNavigatirKey = GlobalKey<NavigatorState>();

    static GoRouter get router = > GoRouter(
        navigatorKey: _rootNavigatirKey,
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => _withAuth(const SplashPage()),
          ),
          GoRoute(
            path: '/login',
            builder: (_, __) => _withAuth(const LoginPage()),
          ),
          GoRoute(
            path: '/register',
            builder: (_, __) => const RegisterPage(),
          ),
          GoRoute(
            path: '/verify-email',
            builder: (_, __) => const VerifyEmailPage(),
          ),
          GoRoute(
            path: '/setup-2fa',
            builder: (_, __) => const Setup2FAPage(),
          ),
        ],
    );
}