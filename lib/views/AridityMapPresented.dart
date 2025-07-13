import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kang/repos/test_repo.dart';
import 'package:latlong2/latlong.dart';

@RoutePage()
class AridityMapPresentedPage extends ConsumerStatefulWidget {
  LatLng? position;

  AridityMapPresentedPage({super.key, required this.position});

  @override
  _AridityMapPresentedPageState createState() => _AridityMapPresentedPageState();
}

class _AridityMapPresentedPageState extends ConsumerState<AridityMapPresentedPage> {
  double mapSize = 1;
  bool refreshing = false;

  @override
  Widget build(BuildContext context) {
    final call = ref.watch(aridityImageServiceProvider(widget.position!));
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
          onRefresh: () async {
            ref.refresh(aridityImageServiceProvider(widget.position!).future);
            ref.refresh(apiServiceProvider(widget.position!).future);
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                /// Map Section
                SizedBox(
                  height: 400, // You can tweak this based on design
                  width: MediaQuery.of(context).size.width,
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
                                  imageProvider: MemoryImage(test!),
                                )
                              ],
                            ),
                          ],
                        );
                      },
                      error: (err, stactrace) => Text(err.toString()),
                      loading: () => Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),

                /// Bottom Info Container
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 30),
                  padding: EdgeInsets.all(24),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: text.when(
                    skipLoadingOnRefresh: false,
                    data: (data) => Text(
                      data.greeting ?? 'No message',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    error: (err, stactrace) => Text(err.toString()),
                    loading: () => Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
