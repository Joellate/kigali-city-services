import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/listing_model.dart';

class ListingProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ListingModel> _allListings = [];
  List<ListingModel> _userListings = [];
  List<ListingModel> _filteredListings = [];
  ListingModel? _selectedListing;

  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';

  // Getters
  List<ListingModel> get allListings => _allListings;
  List<ListingModel> get userListings => _userListings;
  List<ListingModel> get filteredListings => _filteredListings;
  ListingModel? get selectedListing => _selectedListing;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  // Create listing
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

  // Get all listings
  Future<void> fetchAllListings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allListings = await _firestoreService.getAllListings();
      _filteredListings = _allListings;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get user listings
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

  // Stream all listings
  Stream<List<ListingModel>> streamAllListings() {
    return _firestoreService.streamAllListings();
  }

  // Stream user listings
  Stream<List<ListingModel>> streamUserListings(String userId) {
    return _firestoreService.streamUserListings(userId);
  }

  // Update listing
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

  // Delete listing
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

  // Get listing by ID
  Future<void> getListingById(String listingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedListing = await _firestoreService.getListingById(listingId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search listings
  Future<void> searchListings(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (query.isEmpty) {
        _filteredListings = _allListings;
      } else {
        _filteredListings = _allListings
            .where((listing) =>
                listing.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter by category
  Future<void> filterByCategory(String category) async {
    _selectedCategory = category;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (category == 'All') {
        _filteredListings = _allListings;
      } else {
        _filteredListings = _allListings
            .where((listing) => listing.category == category)
            .toList();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get available categories - always show all from Constants, with count
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

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
