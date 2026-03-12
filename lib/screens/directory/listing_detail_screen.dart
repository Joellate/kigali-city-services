import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/listing_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/review_model.dart';
import '../listings/edit_listing_screen.dart';

class ListingDetailScreen extends StatefulWidget {
  final String listingId;

  const ListingDetailScreen({
    Key? key,
    required this.listingId,
  }) : super(key: key);

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  final _commentController = TextEditingController();
  double _userRating = 5.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListingProvider>(context, listen: false)
          .getListingById(widget.listingId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _openGoogleMapsDirections(double latitude, double longitude) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving',
    );
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, String listingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Listing'),
        content: const Text('Are you sure you want to delete this listing?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await Provider.of<ListingProvider>(context, listen: false).deleteListing(listingId);
              if (success && mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddReviewDialog(ListingProvider provider, AuthProvider authProvider) {
    double tempRating = 5.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Write a Review',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < tempRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                    onPressed: () {
                      setSheetState(() {
                        tempRating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add your comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_commentController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please add a comment')),
                      );
                      return;
                    }
                    final review = ReviewModel(
                      id: '',
                      listingId: widget.listingId,
                      userId: authProvider.user!.uid,
                      userName: authProvider.user!.email?.split('@')[0] ?? 'User',
                      rating: tempRating,
                      comment: _commentController.text,
                      timestamp: DateTime.now(),
                    );
                    provider.addReview(review);
                    _commentController.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Submit Review'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listing Details')),
      body: Consumer2<ListingProvider, AuthProvider>(
        builder: (context, provider, authProvider, _) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          final listing = provider.selectedListing;
          if (listing == null) return const Center(child: Text('Listing not found'));
          final isOwner = listing.createdBy == authProvider.user?.uid;
          final averageRating = provider.getAverageRating();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(listing.latitude, listing.longitude),
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                      MarkerLayer(markers: [
                        Marker(
                          point: LatLng(listing.latitude, listing.longitude),
                          width: 40, height: 40,
                          child: const Icon(Icons.place, color: Colors.red, size: 40),
                        ),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listing.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    Text(averageRating == 0 ? 'No ratings' : averageRating.toStringAsFixed(1),
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(' (${provider.reviews.length} reviews)', style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isOwner) 
                            IconButton(onPressed: () => _showDeleteConfirmation(context, listing.id), icon: const Icon(Icons.delete, color: Colors.red)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${listing.category} • ${listing.address}', style: TextStyle(color: Colors.grey.shade700)),
                      const SizedBox(height: 16),
                      Text(listing.description),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _openGoogleMapsDirections(listing.latitude, listing.longitude),
                        icon: const Icon(Icons.navigation),
                        label: const Text('Navigate with Google Maps'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      ),
                      if (isOwner) ...[
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditListingScreen(listing: listing))),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Listing'),
                        ),
                      ],
                      const Divider(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          TextButton.icon(
                            onPressed: () => _showAddReviewDialog(provider, authProvider),
                            icon: const Icon(Icons.add_comment),
                            label: const Text('Write a Review'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (provider.error != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.red.shade50,
                          child: Text(
                            'Error: ${provider.error}',
                            style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                          ),
                        ),
                      if (provider.reviews.isEmpty)
                        const Center(child: Text('No reviews yet. Be the first!'))
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.reviews.length,
                          itemBuilder: (context, index) {
                            final review = provider.reviews[index];
                            return ListTile(
                              leading: const CircleAvatar(child: Icon(Icons.person)),
                              title: Row(
                                children: [
                                  Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const Spacer(),
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  Text(' ${review.rating.toInt()}'),
                                ],
                              ),
                              subtitle: Text(review.comment),
                            );
                          },
                        ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
