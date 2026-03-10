# Kigali City Services & Places Directory

A clean, scalable Flutter mobile application that helps Kigali residents find essential services and leisure places such as hospitals, police stations, libraries, restaurants, cafés, parks, and tourist attractions.

## Features

✅ **Authentication**
- Firebase Authentication with email/password
- Email verification before accessing the app
- User profile management in Firestore

✅ **Listings Management**
- Create, read, update, and delete listings
- Real-time updates using Firestore streams
- User-specific listings management

✅ **Discovery & Search**
- Browse all available listings
- Search listings by name
- Filter listings by category
- Real-time category-based filtering

✅ **Map Integration**
- View all listings on an interactive Google Map
- Markers with listing information
- Direct navigation to Google Maps

✅ **User Experience**
- Clean Material Design UI
- Responsive layout
- Bottom navigation with 4 main sections
- Comprehensive error handling

## Project Structure

```
lib/
  main.dart                              # App entry point
  firebase_options.dart                  # Firebase configuration
  
  models/
    user_model.dart                      # User data model
    listing_model.dart                   # Listing data model
  
  services/
    auth_service.dart                    # Firebase authentication service
    firestore_service.dart               # Firestore database service
  
  providers/
    auth_provider.dart                   # Auth state management
    listing_provider.dart                # Listings state management
  
  screens/
    auth/
      login_screen.dart                  # Login page
      signup_screen.dart                 # Sign up page
      email_verification_screen.dart     # Email verification page
    home/
      main_navigation.dart               # Bottom navigation
    directory/
      directory_screen.dart              # Browse all listings
      listing_detail_screen.dart         # Listing details with map
    listings/
      create_listing_screen.dart         # Create new listing
      edit_listing_screen.dart           # Edit existing listing
      my_listings_screen.dart            # User's listings
    map/
      map_view_screen.dart               # Map view of all listings
    settings/
      settings_screen.dart               # User settings
  
  widgets/
    listing_card.dart                    # Reusable listing card widget
    search_bar.dart                      # Search widget
    category_filter.dart                 # Category filter widget
  
  utils/
    constants.dart                       # App constants
```

## Technology Stack

- **Flutter**: Latest stable version
- **Firebase Core**: ^2.24.0
- **Firebase Authentication**: ^4.14.0
- **Cloud Firestore**: ^4.13.0
- **Google Maps Flutter**: ^2.5.0
- **Provider**: ^6.0.0 (State Management)
- **Geolocator**: ^9.0.2 (Location services)
- **Intl**: ^0.19.0 (Internationalization)
- **URL Launcher**: ^6.1.0 (Navigation links)

## Getting Started

### Prerequisites

1. Flutter SDK (3.0.0 or higher)
2. Firebase project
3. Google Maps API key

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd kigali_city_services
```

2. **Get dependencies**
```bash
flutter pub get
```

3. **Firebase Setup**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use existing one
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Generate Firebase configuration files
   - Update `lib/firebase_options.dart` with your credentials

4. **Google Maps Setup**
   - Generate Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Android: Update `android/app/src/main/AndroidManifest.xml`
   - iOS: Update `ios/Runner/GoogleService-Info.plist`

5. **Run the app**
```bash
flutter run
```

## Firebase Configuration

### Firestore Collections Structure

#### Users Collection
```
users/
  {uid}/
    - uid: String
    - email: String
    - createdAt: Timestamp
```

#### Listings Collection
```
listings/
  {docId}/
    - name: String
    - category: String
    - address: String
    - contactNumber: String
    - description: String
    - latitude: Double
    - longitude: Double
    - createdBy: String (user UID)
    - timestamp: Timestamp
```

### Firestore Security Rules

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User profiles - only owner can read/write
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // Listings - everyone can read, authenticated users can create
    match /listings/{document=**} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                       request.resource.data.createdBy == request.auth.uid;
      allow update, delete: if request.auth != null && 
                               request.auth.uid == resource.data.createdBy;
    }
  }
}
```

## Key Features Explained

### 1. Authentication Flow
- Users sign up with email and password
- Email verification is required before accessing the main app
- User data is stored in Firestore
- Login redirects users to home if email is verified

### 2. Directory Screen
- Displays all listings with search and filter capabilities
- Search by listing name (real-time)
- Filter by category
- Click on listing card to view details
- FAB to create new listing

### 3. Listing Details
- Full listing information
- Google Map with marker showing location
- Button to open Google Maps for navigation
- Edit/Delete options for listing owner

### 4. Map View
- Interactive Google Map
- Markers for all listings
- Info windows with listing details
- Centered on Kigali

### 5. My Listings
- Stream of user's created listings
- Quick access to edit/delete options
- Real-time updates

### 6. Settings
- Display user email
- Location-based notifications toggle
- Logout functionality

## State Management with Provider

The app uses Provider for efficient state management:

### AuthProvider
- Manages user authentication state
- Handles sign up, login, logout
- Tracks email verification status
- Error handling

### ListingProvider
- Manages all listing operations
- Real-time filtering and searching
- CRUD operations
- Loading and error states

## Navigation Structure

```
AuthWrapper
├── LoginScreen (not authenticated)
├── SignupScreen
├── EmailVerificationScreen (not verified)
└── MainNavigation (verified user)
    ├── DirectoryScreen
    ├── MyListingsScreen
    ├── MapViewScreen
    └── SettingsScreen
```

## Development Notes

### Adding a New Category
1. Update the `_categories` list in `CreateListingScreen` and `EditListingScreen`
2. Add to `Constants.categories` if needed

### Extending Map Functionality
- Replace hardcoded Kigali coordinates with user location
- Use Geolocator to get device location
- Implement location-based filtering

### Error Handling
- AuthService provides detailed error messages
- Try-catch blocks in all async operations
- User-friendly error notifications via SnackBar

## Production Checklist

- [ ] Replace Firebase credentials in `firebase_options.dart`
- [ ] Add Google Maps API key
- [ ] Update app name and icons
- [ ] Configure release signing keys
- [ ] Enable appropriate Firestore rules
- [ ] Set up Firebase Analytics
- [ ] Test on physical devices
- [ ] Configure app store/play store listings

## Troubleshooting

### Firebase Connection Issues
- Verify Firebase project configuration
- Check internet connectivity
- Ensure Firebase rules allow operations

### Google Maps Not Displaying
- Verify API key is enabled
- Check AndroidManifest.xml and GoogleService-Info.plist
- Ensure Google Maps services are enabled in Console

### Email Verification Not Working
- Check Firebase Email Templates configuration
- Verify email provider settings
- Check spam folder

## Contribution Guidelines

1. Follow Dart style guide
2. Keep functions focused and small
3. Add comments for complex logic
4. Test changes thoroughly
5. Update documentation as needed

## License

This project is provided as-is for educational purposes.

## Support

For issues and questions, please refer to:
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Documentation](https://flutter.dev/docs)
- [Google Maps Flutter Documentation](https://pub.dev/packages/google_maps_flutter)

---

**Version**: 1.0.0  
**Last Updated**: March 2026
