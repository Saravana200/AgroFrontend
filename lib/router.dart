import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:kang/views/AridityMapPresented.dart';
import 'package:kang/views/MapCoordinatesSelector.dart';
import 'package:kang/views/SoilMoistureMapPresented.dart';
import 'package:kang/views/homepage.dart';
import 'package:kang/views/login.dart';
import 'package:kang/views/otp.dart';
import 'package:kang/views/profile.dart';
import 'package:kang/views/signup.dart';
import 'package:kang/views/start.dart';
import 'package:latlong2/latlong.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AutoRouter extends _$AutoRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SignupRoute.page, path: "/"),
        AutoRoute(page: LoginRoute.page, path: "/login"),
        AutoRoute(page: OtpRoute.page, path: "/otp"),
        AutoRoute(page: AridityMapPresentedRoute.page, path: "/ariditymap"),
        AutoRoute(
            page: SoilMoistureMapPresentedRoute.page, path: "/soilmoisturemap"),
        AutoRoute(
          page: MyAppRoute.page,
          path: "/home",
          initial: true,
          children: [
            AutoRoute(
                page: MapCoordinatesSelectorRoute.page, path: "displayImage"),
            AutoRoute(page: ProfileRoute.page, path: "profile"),
            AutoRoute(page: HomeRoute.page, path: "welcome"),
          ],
        ),
      ];
}
