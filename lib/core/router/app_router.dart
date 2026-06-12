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
          GoRoute(
            path: '/2fa/smtp',
            builder: (_, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return _withOtp(TwoFASmtpPage(mode: extra?['mode'] as String? ?? 'login'));
            },
          ),
          GoRoute(
            path: '/2fa/totp',
            builder: (_, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return _withOtp(TwoFATotpPage(mode: extra?['mode'] as String? ?? 'login'));
            },
          ),
          GoRoute(
            path: '/2fa/notif',
            builder: (_, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return _withOtp(TwoFANotifPage(mode: extra?['mode'] as String? ?? 'login'));
            },
          ),
        ],
    );
}