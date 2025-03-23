import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  String barcode;
  double mrp;
  double price;
  int stock;
  Timestamp createdAt;

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.mrp,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json, String id) {
    return Product(
      id: id,
      name: json["name"] ?? "",
      barcode: json["barcode"] ?? "",
      mrp: (json["mrp"] ?? 0).toDouble(),
      price: (json["price"] ?? 0).toDouble(),
      stock: json["stock"] ?? 0,
      createdAt: json["createdAt"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "barcode": barcode,
      "mrp": mrp,
      "price": price,
      "stock": stock,
      "createdAt": createdAt,
    };
  }
}
