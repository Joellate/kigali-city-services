# Kigali City Services

Flutter app for finding services and places in Kigali (hospitals, police, libraries, restaurants, cafés, parks, etc.).

## Features

**Auth**
- Email/password sign up and login
- Email verification before using the app
- User profile stored in Firestore

**Listings**
- Create, read, update, delete listings
- Listings update in real time (Firestore streams)
- Users only manage their own listings

**Browse and search**
- List all listings, search by name, filter by category
- Category chips at top, search bar, "Near you" list with distance

**Map**
- Map view with all listings (OpenStreetMap)
- Listing detail has a small map and a button to open Google Maps for directions

**UI**
- Bottom nav: Directory, My Listings, Map, Settings
- Dark blue theme, basic error messages via SnackBar

## Project structure

```
lib/
  main.dart
  firebase_options.dart
  models/          user_model, listing_model
  services/        auth_service, firestore_service
  providers/       auth_provider, listing_provider
  screens/         auth, directory, listings, map, settings
  widgets/         listing_card, search_bar, category_filter
  utils/           constants, location_utils
```

## Stack

- Flutter, Firebase (Auth, Firestore)
- Provider for state
- flutter_map + latlong2 for map (OpenStreetMap tiles)
- geolocator for distance, url_launcher for Google Maps link

## Setup

1. Clone, then `flutter pub get`
2. Create a Firebase project, enable Auth (email/password) and Firestore
3. Add `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS), and fill `lib/firebase_options.dart` with your project config
4. Run `flutter run`

See `FIREBASE_DATABASE_SETUP.md` for Firestore rules and collection layout.

## Firestore

- **users** – doc per user (uid, email, createdAt)
- **listings** – name, category, address, contactNumber, description, latitude, longitude, createdBy, timestamp

Rules: users can read/write own profile; anyone logged in can read listings; only creator can create/update/delete their listings.

## License

MIT.
