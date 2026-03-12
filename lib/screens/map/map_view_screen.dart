import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../providers/listing_provider.dart';
import '../directory/listing_detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
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
      appBar: AppBar(title: const Text('Map View')),
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListingDetailScreen(listingId: listing.id),
                          ),
                        );
                      },
                      child: const Icon(Icons.place, color: Colors.red, size: 40),
                    ),
                  ))
              .toList();

          return FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(-1.9536, 29.8739),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }
}
