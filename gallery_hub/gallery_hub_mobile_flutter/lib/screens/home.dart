import 'package:flutter/material.dart';
import 'package:gallery_hub_mobile_flutter/screens/create_album.dart';
import 'package:gallery_hub_mobile_flutter/screens/upload_photo.dart';
import 'package:gallery_hub_mobile_flutter/screens/view_album.dart';
import 'package:gallery_hub_mobile_flutter/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;


  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppConstants.appBackgroundColor),

      // ----------------------------------------------------------
      // APP BAR
      // ----------------------------------------------------------
      appBar: AppBar(
        backgroundColor: const Color(AppConstants.appPrimaryColor),
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,

        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(Icons.image_outlined, size: 26),
            ),

            const SizedBox(width: 14),

            const Text(
              'Gallery Hub',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement search
            },
            icon: const Icon(Icons.search, size: 30),
          ),

          IconButton(
            onPressed: () {
              // TODO: Show menu
            },
            icon: const Icon(Icons.more_vert, size: 30),
          ),

          const SizedBox(width: 8),
        ],
      ),

      // ----------------------------------------------------------
      // BODY
      // ----------------------------------------------------------
      body: <Widget>[
        ViewAlbumScreen(),
        CreateAlbumScreen(),
        UploadPhotoScreen(albumUuid: 'asfafda', albumTitle: 'hello')
      ][_selectedIndex],

      // ----------------------------------------------------------
      // FLOATING ACTION BUTTON
      // ----------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF208F8B),
        foregroundColor: Colors.white,
        elevation: 5,
        child: const Icon(Icons.camera_alt_outlined, size: 28),
      ),

      // ----------------------------------------------------------
      // BOTTOM NAVIGATION BAR
      // ----------------------------------------------------------
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onBottomNavTapped,
        
        backgroundColor: Colors.white,
        elevation: 5,

        indicatorColor: const Color(0xFFD5F0EE),

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Albums',
          ),

          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt),
            label: 'Add Photo',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

