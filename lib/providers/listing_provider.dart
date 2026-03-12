import 'dart:async';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/listing_model.dart';
import '../models/review_model.dart';

class ListingProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _listingsSubscription;
  StreamSubscription? _reviewsSubscription;
  StreamSubscription? _selectedListingSubscription;

  List<ListingModel> _allListings = [];
  List<ListingModel> _userListings = [];
  List<ListingModel> _filteredListings = [];
  List<ReviewModel> _reviews = [];
  ListingModel? _selectedListing;

  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<ListingModel> get allListings => _allListings;
  List<ListingModel> get userListings => _userListings;
  List<ListingModel> get filteredListings => _filteredListings;
  List<ReviewModel> get reviews => _reviews;
  ListingModel? get selectedListing => _selectedListing;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  ListingProvider() {
    _initListingsStream();
  }

  void _initListingsStream() {
    _isLoading = true;
    _listingsSubscription?.cancel();
    _listingsSubscription = _firestoreService.streamAllListings().listen(
      (listings) {
        _allListings = listings;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void _applyFilters() {
    List<ListingModel> results = _allListings;

    // Filter by category
    if (_selectedCategory != 'All') {
      results = results.where((l) => l.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      results = results
          .where((l) =>
              l.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    _filteredListings = results;
  }

  @override
  void dispose() {
    _listingsSubscription?.cancel();
    _reviewsSubscription?.cancel();
    _selectedListingSubscription?.cancel();
    super.dispose();
  }

  Future<bool> createListing(ListingModel listing) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.createListing(listing);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchAllListings() async {
    // Now handled by stream, but keeping for compatibility if needed
    _initListingsStream();
  }

  Future<void> fetchUserListings(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userListings = await _firestoreService.getUserListings(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<ListingModel>> streamAllListings() {
    return _firestoreService.streamAllListings();
  }

  Stream<List<ListingModel>> streamUserListings(String userId) {
    return _firestoreService.streamUserListings(userId);
  }

  Future<bool> updateListing(String listingId, ListingModel listing) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.updateListing(listingId, listing);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteListing(String listingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.deleteListing(listingId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getListingById(String listingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Immediate fetch for initial UI
      _selectedListing = await _firestoreService.getListingById(listingId);
      _isLoading = false;
      notifyListeners();
      
      // Start listening to listing changes
      _selectedListingSubscription?.cancel();
      _selectedListingSubscription = _firestoreService.streamListingById(listingId).listen((listing) {
        _selectedListing = listing;
        notifyListeners();
      });

      // Start listening to reviews for this listing
      _error = null;
      _reviewsSubscription?.cancel();
      _reviewsSubscription = _firestoreService.streamReviewsForListing(listingId).listen(
        (reviews) {
          // Client-side sort by timestamp descending
          reviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          _reviews = reviews;
          notifyListeners();
        },
        onError: (e) {
          _error = e.toString();
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchListings(String query) async {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  Future<void> addReview(ReviewModel review) async {
    _error = null;
    try {
      await _firestoreService.addReview(review);
    } catch (e) {
      _error = 'Error adding review: $e';
      notifyListeners();
    }
  }

  double getAverageRating() {
    if (_reviews.isEmpty) return 0.0;
    double sum = _reviews.fold(0.0, (previous, review) => previous + review.rating);
    return sum / _reviews.length;
  }

  Future<void> filterByCategory(String category) async {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  List<String> getCategories() {
    return const [
      'All',
      'Hospital',
      'Police Station',
      'Library',
      'Restaurant',
      'Café',
      'Park',
      'Tourist Attraction',
      'School',
      'Bank',
      'Pharmacy',
      'Other',
    ];
  }

  int getCountForCategory(String category) {
    if (category == 'All') return _allListings.length;
    return _allListings.where((l) => l.category == category).length;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
