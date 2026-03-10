import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/listing_provider.dart';
import '../directory/directory_screen.dart';
import '../listings/my_listings_screen.dart';
import '../map/map_view_screen.dart';
import '../settings/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = const [
      DirectoryScreen(),
      MyListingsScreen(),
      MapViewScreen(),
      SettingsScreen(),
    ];

    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final listingProvider = Provider.of<ListingProvider>(context, listen: false);
      listingProvider.fetchAllListings();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        listingProvider.fetchUserListings(authProvider.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A237E),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1A237E),
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.white70,
          items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library),
            label: 'Directory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'My Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        ),
      ),
    );
  }
}
