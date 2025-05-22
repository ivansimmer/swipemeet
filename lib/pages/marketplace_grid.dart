import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarketplaceGrid extends StatelessWidget {
  final String searchQuery;

  const MarketplaceGrid({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var products = snapshot.data!.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return data['title'].toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            var data = products[index].data() as Map<String, dynamic>;
            String productId = products[index].id;
            String createdByUid = data['createdBy'];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(createdByUid).get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return const ListTile(title: Text('Loading user...'));
                var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                String userName = userData['name'] ?? 'Unknown User';

                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.network(
                          data['imageUrls'][0] ?? 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png?v=1530129081',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Precio: €${data['price']?.toStringAsFixed(2) ?? '0.00'}'),
                            Text('Anuncio de: $userName', style: const TextStyle(fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}