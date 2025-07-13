import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kang/router.dart';
import 'package:latlong2/latlong.dart';

@RoutePage()
class MapCoordinatesSelectorPage extends StatefulWidget {
  const MapCoordinatesSelectorPage({super.key});

  @override
  State<MapCoordinatesSelectorPage> createState() =>
      _MapCoordinatesSelectorPageState();
}

class _MapCoordinatesSelectorPageState
    extends State<MapCoordinatesSelectorPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<Position> currentLocation() async {
    await Geolocator.isLocationServiceEnabled();
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  List<Marker> markers = List.empty(growable: true);
  LatLng? chosenPostion;
  LatLng? defaultPos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<Position>(
            future: currentLocation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final position = snapshot.data!;
                defaultPos = LatLng(position.latitude, position.longitude);
                return FlutterMap(
                  options: MapOptions(
                    onLongPress: (tapPosition, point) {
                      setState(() {
                        chosenPostion = point;
                        print(chosenPostion!.latitude);
                        markers.add(Marker(
                            point: chosenPostion ??
                                LatLng(position.latitude, position.longitude),
                            child:Icon(Icons.location_on, color: Colors.red)));
                      });
                    },
                    initialCenter: LatLng(position.latitude, position.longitude),
                    minZoom: 7.5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    CurrentLocationLayer(),
                    CircleLayer(
                      circles: [
                        CircleMarker(
                            color: Colors.green[200]!.withOpacity(0.7),
                            point: chosenPostion??LatLng(position.latitude, position.longitude),
                            radius: 100)
                      ],
                    ),
                    MarkerLayer(
                      markers: markers,
                    ),
                    // OverlayImageLayer(
                    //   overlayImages: [
                    //     OverlayImage(
                    //       bounds: LatLngBounds(
                    //         LatLng(position.latitude + 0.1,
                    //             position.longitude - 0.3),
                    //         LatLng(position.latitude - 0.1,
                    //             position.longitude + 0.3),
                    //       ),
                    //       imageProvider: NetworkImage(
                    //           "https://docs.fleaflet.dev/~gitbook/image?url=https%3A%2F%2Fcontent.gitbook.com%2Fcontent%2F6crWs9H40DxNQrzXYdrt%2Fblobs%2FPvgy4YVJydNXu0wuJPR7%2FExampleImageOverlay.png&width=400&dpr=3&quality=100&sign=3d45f68b4aa3d70b60f7517909078945189e0f60eb1be34e1781d117ee91e28e",
                    //           scale: 900),
                    //     )
                    //   ],
                    // )
                  ],
                );
              }
            },
          ),
          Positioned(
            bottom: 0,
            right: MediaQuery.of(context).size.width / 1.88,
            child: ElevatedButton(
              onPressed: () {
                context.router.push(
                  AridityMapPresentedRoute(
                    position: chosenPostion ?? defaultPos,
                  ),
                );
              },
              child: Text("Submit Soil Aridity"),
            ),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 1.88,
            child: ElevatedButton(
              onPressed: () {
                context.router.push(
                  SoilMoistureMapPresentedRoute(
                    position: chosenPostion ?? defaultPos,
                  ),
                );
              },
              child: Text("Submit Soil Moisture"),
            ),
          ),
        ],
      ),
    );
  }
}
