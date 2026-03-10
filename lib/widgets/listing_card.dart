import 'package:flutter/material.dart';
import '../models/listing_model.dart';

class ListingCard extends StatelessWidget {
  final ListingModel listing;
  final VoidCallback onTap;
  final String? distanceText;

  const ListingCard({
    Key? key,
    required this.listing,
    required this.onTap,
    this.distanceText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(5, (i) => Icon(
                          i < 4 ? Icons.star : Icons.star_half,
                          size: 16,
                          color: Colors.amber.shade700,
                        )),
                        const SizedBox(width: 4),
                        Text(
                          '4.0',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    if (distanceText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        distanceText!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
