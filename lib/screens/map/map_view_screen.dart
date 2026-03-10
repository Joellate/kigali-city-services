import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../providers/listing_provider.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListingProvider>(context, listen: false).fetchAllListings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<ListingProvider>(
        builder: (context, listingProvider, _) {
          if (listingProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final markers = listingProvider.allListings
              .map((listing) => Marker(
                    point: LatLng(listing.latitude, listing.longitude),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.place,
                      color: Colors.red,
                      size: 40,
                    ),
                  ))
              .toList();

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-1.9536, 29.8739),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.kigali_city_services',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }
}
