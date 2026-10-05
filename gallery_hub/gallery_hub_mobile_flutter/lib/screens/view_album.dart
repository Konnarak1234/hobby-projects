import 'package:flutter/material.dart';
import 'package:gallery_hub_mobile_flutter/widgets/album_card.dart';

class ViewAlbumScreen extends StatelessWidget {

  ViewAlbumScreen({super.key});

  final List<Map<String, dynamic>> albums = [
    {
      'title': 'Travel',
      'description': 'Beautiful places around the world',
      'photoCount': 24,
      'updated': 'Updated 2 days ago',
      'image':
          'https://images.unsplash.com/photo-1500534623283-312aade485b7?w=500',
    },
    {
      'title': 'Pets',
      'description': 'My furry friends',
      'photoCount': 12,
      'updated': 'Updated 4 days ago',
      'image':
          'https://images.unsplash.com/photo-1552053831-71594a27632d?w=500',
    },
    {
      'title': 'Family',
      'description': 'Special moments together',
      'photoCount': 18,
      'updated': 'Updated 1 week ago',
      'image':
          'https://images.unsplash.com/photo-1504150558240-0b4fd8946624?w=500',
    },
    {
      'title': 'City Life',
      'description': 'Urban adventures and everyday moments',
      'photoCount': 15,
      'updated': 'Updated 1 week ago',
      'image':
          'https://images.unsplash.com/photo-1518391846015-55a9cc003b25?w=500',
    },
    {
      'title': 'Nature',
      'description': 'The beauty of the outdoors',
      'photoCount': 10,
      'updated': 'Updated 2 weeks ago',
      'image':
          'https://images.unsplash.com/photo-1497250681960-ef046c08a56e?w=500',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CustomScrollView(
          slivers: [
            // ----------------------------------------------------
            // HEADER
            // ----------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Albums',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'Your memories, organized beautifully',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF78909C),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    FilledButton.icon(
                      onPressed: () {
                        // TODO: Create new album
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF208F8B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'New Album',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ----------------------------------------------------
            // ALBUM LIST
            // ----------------------------------------------------
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList.builder(
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];

                  return AlbumCard(
                    title: album['title'],
                    description: album['description'],
                    photoCount: album['photoCount'],
                    updated: album['updated'],
                    imageUrl: album['image'],
                    onTap: () {
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}