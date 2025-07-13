import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kang/repos/test_repo.dart';
import 'package:latlong2/latlong.dart';

@RoutePage()
class SoilMoistureMapPresentedPage extends ConsumerStatefulWidget {
  final LatLng? position;

  SoilMoistureMapPresentedPage({super.key, required this.position});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SoilMoistureMapPresentedPage> {
  double mapSize = 1;
  bool refreshing = false;
  @override
  Widget build(BuildContext context) {
    final call = ref.watch(imageServiceProvider(widget.position!));
    final text = ref.watch(apiServiceProvider(widget.position!));

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weather Details'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.router.pop();
            },
          ),
        ),
        body: RefreshIndicator(
          // Refresh both providers
          onRefresh: () async {
            ref.refresh(imageServiceProvider(widget.position!).future);
            ref.refresh(apiServiceProvider(widget.position!).future);
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              /// Map section
              SizedBox(
                height: 400, // set a fixed height instead of using Expanded
                child: Center(
                  child: call.when(
                    skipLoadingOnRefresh: false,
                    data: (test) {
                      return FlutterMap(
                        options: MapOptions(
                          initialCenter: widget.position!,
                          minZoom: 11.5,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          CurrentLocationLayer(),
                          OverlayImageLayer(
                            overlayImages: [
                              OverlayImage(
                                opacity: 0.74,
                                bounds: LatLngBounds(
                                  LatLng(widget.position!.latitude + 0.1,
                                      widget.position!.longitude - 0.1),
                                  LatLng(widget.position!.latitude - 0.1,
                                      widget.position!.longitude + 0.1),
                                ),
                                imageProvider: MemoryImage(test!, scale: 20),
                              )
                            ],
                          )
                        ],
                      );
                    },
                    error: (err, stactrace) =>
                        Center(child: Text(err.toString())),
                    loading: () => Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),

              /// Text content section
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 30),
                padding: EdgeInsets.all(24),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: text.when(
                  skipLoadingOnRefresh: false,
                  data: (data) => Text(
                    data.greeting ?? '',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  error: (err, stacktrace) => Text(err.toString()),
                  loading: () => Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
