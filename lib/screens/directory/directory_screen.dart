import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/listing_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/listing_card.dart';
import '../../widgets/search_bar.dart' as custom;
import '../../widgets/category_filter.dart';
import '../../utils/constants.dart';
import '../../utils/location_utils.dart';
import 'listing_detail_screen.dart';
import '../listings/create_listing_screen.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({Key? key}) : super(key: key);

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListingProvider>(context, listen: false).fetchAllListings();
      _getUserLocation();
    });
  }

  Future<void> _getUserLocation() async {
    try {
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      if (await Geolocator.isLocationServiceEnabled()) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
        if (mounted) setState(() => _userPosition = pos);
      }
    } catch (_) {
      final defaultLat = double.tryParse(Constants.defaultCityLatitude) ?? -1.9536;
      final defaultLon = double.tryParse(Constants.defaultCityLongitude) ?? 29.8739;
      if (mounted) {
        setState(() => _userPosition = Position(
          latitude: defaultLat,
          longitude: defaultLon,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        ));
      }
    }
  }

  String? _getDistance(double lat, double lon) {
    if (_userPosition == null) return null;
    return formatDistance(
      _userPosition!.latitude,
      _userPosition!.longitude,
      lat,
      lon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kigali City'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryFilter(
            onCategorySelected: (category) {
              Provider.of<ListingProvider>(context, listen: false)
                  .filterByCategory(category);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: custom.SearchBar(
              hintText: 'Search for a service',
              onSearch: (query) {
                Provider.of<ListingProvider>(context, listen: false)
                    .searchListings(query);
              },
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Near You',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<ListingProvider>(
              builder: (context, listingProvider, _) {
                if (listingProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (listingProvider.filteredListings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No services found',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: listingProvider.filteredListings.length,
                  itemBuilder: (context, index) {
                    final listing = listingProvider.filteredListings[index];
                    return ListingCard(
                      listing: listing,
                      distanceText: _getDistance(listing.latitude, listing.longitude),
                      rating: listing.averageRating,
                      reviewCount: listing.reviewCount,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ListingDetailScreen(
                              listingId: listing.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreateListingScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
