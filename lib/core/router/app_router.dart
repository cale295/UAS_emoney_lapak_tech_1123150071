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
          GoRoute(path: '/topup', builder: (_, __) => _withPayment(const TopUpPage())),
          GoRoute(path: '/transfer', builder: (_, __) => const TransferPage()),
          GoRoute(
            path: '/transfer/amount',
            builder: (_, state) {
              final extra = state.extra as Map<String, dynamic>;
              return _withAccount(TransferAmountPage(
                recipient: extra['recipient'] as Map<String, dynamic>,
                channel: extra['channel'] as String,
              ));
            },
          ),
          GoRoute(
            path: '/transfer/confirm',
            builder: (_, state) {
              final extra = state.extra as Map<String, dynamic>;
              return TransferConfirmPage(
                recipient: extra['recipient'] as Map<String, dynamic>,
                channel: extra['channel'] as String,
                amount: (extra['amount'] as num).toDouble(),
                note: extra['note'] as String? ?? '',
                fee: (extra['fee'] as num? ?? 0).toDouble(),
              );
            },
          ),
          GoRoute(path: '/payment', builder: (_, __) => const PaymentQrPage()),
          GoRoute(
            path: '/pin',
            builder: (_, state) {
              final extra = (state.extra as Map<String, dynamic>?) ?? {};
              return _withPayment(PinPage(flowData: extra));
            },
          ),
          GoRoute(
            path: '/success',
            builder: (_, state) {
              final extra = (state.extra as Map<String, dynamic>?) ?? {};
              return _withAccount(SuccessPage(
                title: extra['title'] as String? ?? 'Berhasil',
                subtitle: extra['subtitle'] as String? ?? '',
                amount: (extra['amount'] as num? ?? 0).toDouble(),
                lines: (extra['lines'] as List<dynamic>?)
                    ?.map((l) => (l as List<dynamic>).map((e) => e.toString()).toList())
                    .toList() ?? [],
              ));
            },
          ),
          GoRoute(path: '/merchant', builder: (_, __) => _withPayment(const MerchantCheckoutPage())),
        ],
    );
}