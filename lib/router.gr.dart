// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AutoRouter extends RootStackRouter {
  // ignore: unused_element
  _$AutoRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AridityMapPresentedRoute.name: (routeData) {
      final args = routeData.argsAs<AridityMapPresentedRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AridityMapPresentedPage(
          key: args.key,
          position: args.position,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginPage(),
      );
    },
    MapCoordinatesSelectorRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MapCoordinatesSelectorPage(),
      );
    },
    MyAppRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MyAppPage(),
      );
    },
    OtpRoute.name: (routeData) {
      final args = routeData.argsAs<OtpRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OtpPage(
          name: args.name,
          phone: args.phone,
          email: args.email,
          password: args.password,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfilePage(),
      );
    },
    SignupRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SignupPage(),
      );
    },
    SoilMoistureMapPresentedRoute.name: (routeData) {
      final args = routeData.argsAs<SoilMoistureMapPresentedRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SoilMoistureMapPresentedPage(
          key: args.key,
          position: args.position,
        ),
      );
    },
  };
}

/// generated route for
/// [AridityMapPresentedPage]
class AridityMapPresentedRoute
    extends PageRouteInfo<AridityMapPresentedRouteArgs> {
  AridityMapPresentedRoute({
    Key? key,
    required LatLng? position,
    List<PageRouteInfo>? children,
  }) : super(
          AridityMapPresentedRoute.name,
          args: AridityMapPresentedRouteArgs(
            key: key,
            position: position,
          ),
          initialChildren: children,
        );

  static const String name = 'AridityMapPresentedRoute';

  static const PageInfo<AridityMapPresentedRouteArgs> page =
      PageInfo<AridityMapPresentedRouteArgs>(name);
}

class AridityMapPresentedRouteArgs {
  const AridityMapPresentedRouteArgs({
    this.key,
    required this.position,
  });

  final Key? key;

  final LatLng? position;

  @override
  String toString() {
    return 'AridityMapPresentedRouteArgs{key: $key, position: $position}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MapCoordinatesSelectorPage]
class MapCoordinatesSelectorRoute extends PageRouteInfo<void> {
  const MapCoordinatesSelectorRoute({List<PageRouteInfo>? children})
      : super(
          MapCoordinatesSelectorRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapCoordinatesSelectorRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyAppPage]
class MyAppRoute extends PageRouteInfo<void> {
  const MyAppRoute({List<PageRouteInfo>? children})
      : super(
          MyAppRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyAppRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OtpPage]
class OtpRoute extends PageRouteInfo<OtpRouteArgs> {
  OtpRoute({
    required String name,
    required String phone,
    required String email,
    required String password,
    List<PageRouteInfo>? children,
  }) : super(
          OtpRoute.name,
          args: OtpRouteArgs(
            name: name,
            phone: phone,
            email: email,
            password: password,
          ),
          initialChildren: children,
        );

  static const String name = 'OtpRoute';

  static const PageInfo<OtpRouteArgs> page = PageInfo<OtpRouteArgs>(name);
}

class OtpRouteArgs {
  const OtpRouteArgs({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  final String name;

  final String phone;

  final String email;

  final String password;

  @override
  String toString() {
    return 'OtpRouteArgs{name: $name, phone: $phone, email: $email, password: $password}';
  }
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignupPage]
class SignupRoute extends PageRouteInfo<void> {
  const SignupRoute({List<PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SoilMoistureMapPresentedPage]
class SoilMoistureMapPresentedRoute
    extends PageRouteInfo<SoilMoistureMapPresentedRouteArgs> {
  SoilMoistureMapPresentedRoute({
    Key? key,
    required LatLng? position,
    List<PageRouteInfo>? children,
  }) : super(
          SoilMoistureMapPresentedRoute.name,
          args: SoilMoistureMapPresentedRouteArgs(
            key: key,
            position: position,
          ),
          initialChildren: children,
        );

  static const String name = 'SoilMoistureMapPresentedRoute';

  static const PageInfo<SoilMoistureMapPresentedRouteArgs> page =
      PageInfo<SoilMoistureMapPresentedRouteArgs>(name);
}

class SoilMoistureMapPresentedRouteArgs {
  const SoilMoistureMapPresentedRouteArgs({
    this.key,
    required this.position,
  });

  final Key? key;

  final LatLng? position;

  @override
  String toString() {
    return 'SoilMoistureMapPresentedRouteArgs{key: $key, position: $position}';
  }
}
