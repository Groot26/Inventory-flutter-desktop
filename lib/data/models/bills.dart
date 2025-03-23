import 'package:cloud_firestore/cloud_firestore.dart';
import 'bill.dart';

class Bill {
  String id;
  List<BillItem> items;
  double totalAmount;
  Timestamp createdAt;

  Bill({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
  });

  /// ✅ Convert Firestore document to `Bill` object
  factory Bill.fromJson(Map<String, dynamic> json, String id) {
    return Bill(
      id: id,
      items: (json['items'] as List<dynamic>?)?.map((item) {
        return BillItem.fromJson(item as Map<String, dynamic>);
      }).toList() ??
          [],
      totalAmount: (json['total'] ?? 0).toDouble(), // ✅ `total` matches Firestore
      createdAt: json['timestamp'] ?? Timestamp.now(), // ✅ `timestamp` matches Firestore
    );
  }

  /// ✅ Convert `Bill` object to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      "items": items.map((item) => item.toJson()).toList(),
      "total": totalAmount, // ✅ Matches Firestore field name
      "timestamp": createdAt, // ✅ Matches Firestore field name
    };
  }
}