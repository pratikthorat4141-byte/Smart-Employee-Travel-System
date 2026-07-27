import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/live_tracking_provider.dart';
import '../../widgets/live_map_widget.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() =>
      _LiveTrackingScreenState();
}

class _LiveTrackingScreenState
    extends State<LiveTrackingScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<LiveTrackingProvider>()
          .loadCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveTrackingProvider>(
      builder: (context, provider, child) {
        final location = provider.currentLocation;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Live Tracking",
            ),
            centerTitle: true,
          ),

          body: Column(
            children: [

              Expanded(
                flex: 3,
                child: const LiveMapWidget(),
              ),

              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(16),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Current Location",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 12),

                              Text(
                                "Latitude : ${location?.latitude.toStringAsFixed(6) ?? "--"}",
                              ),

                              Text(
                                "Longitude : ${location?.longitude.toStringAsFixed(6) ?? "--"}",
                              ),

                              Text(
                                "Speed : ${location?.speed.toStringAsFixed(2) ?? "0"} m/s",
                              ),

                              Text(
                                "Accuracy : ${location?.accuracy.toStringAsFixed(2) ?? "0"} m",
                              ),

                              Text(
                                "Heading : ${location?.heading.toStringAsFixed(2) ?? "0"}°",
                              ),

                              const SizedBox(
                                  height: 10),

                              Text(
                                "Tracking : ${provider.isTracking ? "Running" : "Stopped"}",
                                style:
                                    TextStyle(
                                  color: provider
                                          .isTracking
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [

                          Expanded(
                            child:
                                FilledButton.icon(
                              onPressed:
                                      provider.isTracking
                                  ? null
                                  : () {
                                      provider
                                          .startTracking();
                                    },
                              icon: const Icon(
                                  Icons.play_arrow),
                              label: const Text(
                                  "Start"),
                            ),
                          ),

                          const SizedBox(
                              width: 12),

                          Expanded(
                            child:
                                FilledButton.icon(
                              onPressed:
                                      provider.isTracking
                                  ? () {
                                      provider
                                          .stopTracking();
                                    }
                                  : null,
                              icon: const Icon(
                                  Icons.stop),
                              label: const Text(
                                  "Stop"),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child:
                            OutlinedButton.icon(
                          onPressed: () {
                            provider.refresh();
                          },
                          icon: const Icon(
                              Icons.refresh),
                          label: const Text(
                              "Refresh"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}