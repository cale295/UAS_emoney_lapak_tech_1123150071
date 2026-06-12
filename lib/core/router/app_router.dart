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
          ShellRoute(
            builder: (context, state, child) {
              final location = state.matchedLocation;
              final tab = location.contains('history')
                  ? 'history'
                  : location.contains('promo')
                      ? 'promo'
                      : location.contains('akun')
                          ? 'akun'
                          : 'home';

              return _withAccount(Scaffold(
                body: child,
                bottomNavigationBar: AppTabBar(
                  active: tab,
                  onTab: (t) {
                    switch (t) {
                      case 'history': context.go('/history'); break;
                      case 'promo': context.go('/promo'); break;
                      case 'akun': context.go('/akun'); break;
                      default: context.go('/home');
                    }
                  },
                  onScan: () => context.go('/payment'),
                ),
              ));
            },
            routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomePage()),
              GoRoute(path: '/history', builder: (_, __) => const HistoryPage()),
              GoRoute(path: '/promo', builder: (_, __) => const PromoPage()),
              GoRoute(path: '/akun', builder: (_, __) => const AccountPage()),
            ],
          ),
        ],
    );
}