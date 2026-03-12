# Kigali City Services

A digital companion for discovering essential services and attractions in Kigali, Rwanda.

## Features

### Secure Authentication
- **User Verification**: Mandatory email verification to ensure a secure community.
- **Profile Management**: Personalized user profiles and history.

### Location Services
- **Listing Management**: Complete CRUD operations for service providers (Hospitals, Cafés, Parks, etc.).
- **Real-time Discovery**: Instant search and category-based filtering.
- **Interactive Maps**: Embedded OpenStreetMap views with one-touch external navigation.

### Reviews & Ratings
- **Dynamic Feedback**: Users can leave star ratings and comments.
- **Aggregated Data**: Listings display real-time average ratings and review counts using atomic database transactions.

## Firestore Database Structure

The application uses a flat, high-performance NoSQL structure in Cloud Firestore:

### `listings` Collection
Stores all service and place data.
- **Fields**: `id`, `name`, `category`, `address`, `contactNumber`, `description`, `latitude`, `longitude`, `createdBy` (uid), `timestamp`, `averageRating`, `reviewCount`.

### `reviews` Collection
Stores individual user reviews.
- **Fields**: `id`, `listingId` (reference), `userId`, `userName`, `rating`, `comment`, `timestamp`.

### `users` Collection
Stores extended user profile information.
- **Fields**: `uid`, `email`, `displayName`, `createdAt`.

## State Management

The application utilizes the **Provider** package for state management, following the **ChangeNotifier** pattern.

- **Reactive UI**: The UI automatically rebuilds when data changes in the logic layer.
- **Stream Integration**: `ListingProvider` listens directly to Firestore Snapshots, ensuring that any changes in the database (new reviews, edited listings) are reflected on the user's screen in real-time without manual refreshes.
- **Separation of Concerns**: Business logic is isolated from UI widgets, making the codebase maintainable and testable.
