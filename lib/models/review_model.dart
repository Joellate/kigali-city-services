import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String listingId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime timestamp;

  ReviewModel({
    required this.id,
    required this.listingId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'listingId': listingId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory ReviewModel.fromJson(String id, Map<String, dynamic> json) {
    DateTime ts;
    final timestampData = json['timestamp'];
    if (timestampData is Timestamp) {
      ts = timestampData.toDate();
    } else if (timestampData is String) {
      ts = DateTime.tryParse(timestampData) ?? DateTime.now();
    } else {
      ts = DateTime.now();
    }

    return ReviewModel(
      id: id,
      listingId: json['listingId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Anonymous',
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      timestamp: ts,
    );
  }
}
