class AppRouter {
    static final _rootNavigatirKey = GlobalKey<NavigatorState>();

    static GoRouter get router = > GoRouter(
        navigatorKey: _rootNavigatirKey,
        initialLocation: '/',
        routes: [
            
        ],
    );
}