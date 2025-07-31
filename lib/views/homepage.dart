import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kang/models/models.dart';
import 'package:kang/repos/repository.dart';
import 'package:kang/widgets/NewsWidgetGenerator.dart';
import 'package:kang/widgets/slider.dart';
import 'package:latlong2/latlong.dart';

import '../router.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  var position;

  void getLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Enable Location'),
          content: const Text('Location services are turned off.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await Geolocator.openLocationSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Location Permission Needed'),
            content: const Text(
                'Permission is permanently denied. Enable it in App Settings.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await Geolocator.openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        return;
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Location Permission Denied'),
            content: const Text('Please allow location to continue.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
            ],
          ),
        );
        return;
      }
    }
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    print('Printing text before getCurrentLocation()');
    Position _position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    setState(() {
      position = _position;
    });
    print(position);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final call = position == null
        ? const AsyncValue<WeatherResponse>.loading()
        : ref.watch(
            weatherServiceProvider(
              LatLng(position.latitude, position.longitude),
            ),
          );
    final newsCall = ref.watch(newsServiceProvider);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.12,
        backgroundColor: theme.colorScheme.surface,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: .0),
          child: SizedBox(
            width: 50, // Set your desired width for the image
            height: 20, // Set your desired height for the image
            child: Image.asset(
              "assets/agrifusion.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  height: 1.05,
                  letterSpacing: -0.2,
                ),
            children: [
              TextSpan(
                text: 'Farm Smart,\n',
                style: GoogleFonts.greatVibes(
                    fontSize: 32,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primary),
              ),
              TextSpan(
                  text: ' Not Hard.',
                  style: GoogleFonts.dancingScript(
                      fontSize: 28,
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.secondary)),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to ProfileRoute
                context.router.push(ProfileRoute());
              },
              child: Icon(
                Icons.person_2_outlined,
                size: 32,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Color.fromRGBO(35, 156, 30, 0.18),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.04,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 34),
                  height: size.height * 0.19,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset:
                            const Offset(0, 4), // Position of the shadow (x, y)
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                    color: Color.fromRGBO(237, 241, 237, 1),
                  ),
                  child: call.when(
                    skipLoadingOnRefresh: false,
                    data: (WeatherResponse data) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SliderBar(
                            theme: theme,
                            value: data.temperature - 273.15,
                            minValue: 0,
                            maxValue: 100,
                            currentValue: data.temperature - 273.15,
                            description: "°C",
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cyclone,
                                color: theme.colorScheme.onPrimaryContainer,
                                size: 25,
                              ),
                              Text(
                                data.windSpeed.toString() + "m/s",
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          SliderBar(
                            theme: theme,
                            value: data.humidity.toDouble(),
                            minValue: 0,
                            maxValue: 100,
                            currentValue: data.humidity.toDouble(),
                            icon: Icons.water_drop_rounded,
                            description: "%",
                          ),
                        ],
                      );
                    },
                    error: (Object error, StackTrace stackTrace) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 9),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.error.withOpacity(0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 28,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Location unavailable',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.onErrorContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Please enable Location Services and try again.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onErrorContainer,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          await Geolocator
                                              .openLocationSettings();
                                        },
                                        child: const Text('Open Settings'),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () async {
                                          getLocation();
                                          await ref.refresh(
                                              weatherServiceProvider(new LatLng(
                                                      position.latitude,
                                                      position.longitude))
                                                  .future);
                                        },
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => SizedBox(
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  )),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: size.height * 0.55,
              child: newsCall.when(
                skipLoadingOnRefresh: false,
                data: (response) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref.refresh(newsServiceProvider.future);
                    },
                    child: Scrollbar(
                      radius: const Radius.circular(12),
                      thickness: 6,
                      child: Container(
                        width: size.width * 0.96,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(
                                  0, 4), // Position of the shadow (x, y)
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                          color: Color.fromRGBO(237, 241, 237, 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 17),
                              Text(
                                'News Report',
                                style: GoogleFonts.specialElite(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4.5,
                                  color: Color.fromRGBO(
                                      57, 24, 2, 0.5058823529411764),
                                ),
                              ),
                              const SizedBox(height: 9),
                              SizedBox(
                                height: size.height * 0.45,
                                child: NewsWidgetGenerator(response: response),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.redAccent),
                        const SizedBox(height: 12),
                        const Text(
                          'Failed to load news',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () =>
                              ref.refresh(newsServiceProvider.future),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => Center(
                  child: Container(
                    width: size.width * 0.96,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(
                              0, 4), // Position of the shadow (x, y)
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                      color: Color.fromRGBO(237, 241, 237, 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading latest agriculture news...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
