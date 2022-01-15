import 'package:flutter/material.dart';

class WinnerMaterialApp {
  Key? key;
  GlobalKey<NavigatorState>? navigatorKey;
  GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  Widget? home;
  Map<String, Widget Function(BuildContext)> routes =
      const <String, WidgetBuilder>{};
  String? initialRout;
  Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;
  Route<dynamic>? Function(RouteSettings)? onUnknownRoute;
  List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[];
  Widget Function(BuildContext, Widget?)? builder;
  String title = '';
  String Function(BuildContext)? onGenerateTitle;
  Color? color;
  ThemeData? theme;
  ThemeData? darkTheme;
  ThemeData? highContrastTheme;
  ThemeData? highContrastDarkTheme;
  ThemeMode? themeMode = ThemeMode.system;
  Locale? locale;
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  Locale? Function(List<Locale>?, Iterable<Locale>)?
      localeListResolutionCallback;
  Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback;
  Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')];
  bool debugShowMaterialGrid = false;
  bool showPerformanceOverlay = false;
  bool checkerboardRasterCacheImages = false;
  bool checkerboardOffscreenLayers = false;
  bool showSemanticsDebugger = false;
  bool debugShowCheckedModeBanner = true;
  Map<ShortcutActivator, Intent>? shortcuts;
  Map<Type, Action<Intent>>? actions;
  String? restorationScopeId;
  ScrollBehavior? scrollBehavior;
  bool useInheritedMediaQuery = false;
  MaterialApp get materialApp => MaterialApp(
        key: key,
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: home,
        routes: routes,
        initialRoute: initialRout,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        navigatorObservers: navigatorObservers,
        builder: builder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        theme: theme,
        darkTheme: darkTheme,
        highContrastTheme: highContrastTheme,
        highContrastDarkTheme: highContrastDarkTheme,
        themeMode: themeMode,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        debugShowMaterialGrid: debugShowMaterialGrid,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
        scrollBehavior: scrollBehavior,
        useInheritedMediaQuery: useInheritedMediaQuery,
      );
}
