import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final String title;
  final String description;
  final int photoCount;
  final String updated;
  final String imageUrl;
  final VoidCallback onTap;

  const AlbumCard({
    super.key,
    required this.title,
    required this.description,
    required this.photoCount,
    required this.updated,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),

        child: Padding(
          padding: const EdgeInsets.all(14),

          child: Row(
            children: [
              // ------------------------------------------------
              // ALBUM IMAGE
              // ------------------------------------------------
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.network(
                  imageUrl,
                  width: 105,
                  height: 105,
                  fit: BoxFit.cover,

                  // Display placeholder while image loads
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(
                      width: 105,
                      height: 105,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      ),
                    );
                  },

                  // Display placeholder if image fails
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 105,
                      height: 105,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                        size: 35,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 18),

              // ------------------------------------------------
              // ALBUM INFORMATION
              // ------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF78909C),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          size: 18,
                          color: Color(0xFF78909C),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          '$photoCount photos',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF78909C),
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Text(
                          '•',
                          style: TextStyle(color: Color(0xFF78909C)),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            updated,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF78909C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ------------------------------------------------
              // ARROW
              // ------------------------------------------------
              const Icon(
                Icons.chevron_right,
                size: 30,
                color: Color(0xFF78909C),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
