import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> imageUrls;
  final String createdBy;
  final Timestamp timestamp;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.createdBy,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'createdBy': createdBy,
      'timestamp': timestamp,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      price: map['price'].toDouble(),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      createdBy: map['createdBy'],
      timestamp: map['timestamp'],
    );
  }
} 