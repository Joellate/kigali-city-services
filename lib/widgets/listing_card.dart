import 'package:flutter/material.dart';
import '../models/listing_model.dart';

class ListingCard extends StatelessWidget {
  final ListingModel listing;
  final VoidCallback onTap;
  final String? distanceText;
  final double? rating;
  final int? reviewCount;

  const ListingCard({
    Key? key,
    required this.listing,
    required this.onTap,
    this.distanceText,
    this.rating,
    this.reviewCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${listing.category} • ${listing.address}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber.shade700, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          rating != null && rating! > 0 ? rating!.toStringAsFixed(1) : 'New',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (reviewCount != null && reviewCount! > 0)
                          Text(' ($reviewCount)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        if (distanceText != null) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          Text(' $distanceText', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
