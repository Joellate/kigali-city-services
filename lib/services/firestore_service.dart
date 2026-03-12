import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/listing_model.dart';
import '../models/review_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String> createListing(ListingModel listing) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('listings').add(listing.toJson());
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ListingModel>> getAllListings() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('listings')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
              ListingModel.fromJson(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ListingModel>> getUserListings(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('listings')
          .where('createdBy', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
              ListingModel.fromJson(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ListingModel>> getListingsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('listings')
          .where('category', isEqualTo: category)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
              ListingModel.fromJson(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ListingModel?> getListingById(String listingId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('listings').doc(listingId).get();
      if (doc.exists) {
        return ListingModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Stream<ListingModel?> streamListingById(String listingId) {
    return _firestore
        .collection('listings')
        .doc(listingId)
        .snapshots()
        .map((doc) => doc.exists
            ? ListingModel.fromJson(doc.id, doc.data() as Map<String, dynamic>)
            : null);
  }

  Future<void> updateListing(String listingId, ListingModel listing) async {
    try {
      await _firestore
          .collection('listings')
          .doc(listingId)
          .update(listing.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteListing(String listingId) async {
    try {
      await _firestore.collection('listings').doc(listingId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ListingModel>> streamAllListings() {
    return _firestore
        .collection('listings')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ListingModel.fromJson(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<ListingModel>> streamUserListings(String userId) {
    return _firestore
        .collection('listings')
        .where('createdBy', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ListingModel.fromJson(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<ListingModel>> searchListings(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('listings')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();

      return snapshot.docs
          .map((doc) =>
              ListingModel.fromJson(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addReview(ReviewModel review) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // 1. Get the listing FIRST (best practice in transactions)
        DocumentReference listingRef =
            _firestore.collection('listings').doc(review.listingId);
        DocumentSnapshot listingDoc = await transaction.get(listingRef);

        if (!listingDoc.exists) {
          throw Exception('Listing does not exist');
        }

        // 2. Add the review
        DocumentReference reviewRef = _firestore.collection('reviews').doc();
        transaction.set(reviewRef, review.toJson());

        // 3. Update the listing aggregator
        final data = listingDoc.data() as Map<String, dynamic>;
        final currentRating = (data['averageRating'] ?? 0.0).toDouble();
        final currentCount = (data['reviewCount'] ?? 0).toInt();

        final newCount = currentCount + 1;
        final newAverage = ((currentRating * currentCount) + review.rating) / newCount;

        transaction.update(listingRef, {
          'averageRating': newAverage,
          'reviewCount': newCount,
        });
      }).timeout(const Duration(seconds: 10)); // Add timeout for web stability
    } catch (e) {
      print('Error adding review: $e');
      rethrow;
    }
  }

  Stream<List<ReviewModel>> streamReviewsForListing(String listingId) {
    return _firestore
        .collection('reviews')
        .where('listingId', isEqualTo: listingId)
        // Temporarily removed orderBy to rule out missing index issues
        // .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromJson(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}
