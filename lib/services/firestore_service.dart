import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/listing_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =============== USER OPERATIONS ===============

  // Create user profile
  Future<void> createUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
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

  // =============== LISTING OPERATIONS ===============

  // Create listing
  Future<String> createListing(ListingModel listing) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('listings').add(listing.toJson());
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Get all listings
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

  // Get listings by user
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

  // Get listings by category
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

  // Get listing by ID
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

  // Update listing
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

  // Delete listing
  Future<void> deleteListing(String listingId) async {
    try {
      await _firestore.collection('listings').doc(listingId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // =============== STREAM OPERATIONS ===============

  // Stream all listings
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

  // Stream user listings
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

  // Search listings by name
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
}
