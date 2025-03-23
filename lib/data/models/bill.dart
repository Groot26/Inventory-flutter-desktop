class BillItem {
  String name;
  double price;
  int quantity;
  String barcode;

  BillItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.barcode,
  });

  /// ✅ Convert Firestore document to `BillItem` object
  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      barcode: json['barcode'] ?? '',
    );
  }

  /// ✅ Convert `BillItem` object to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "quantity": quantity,
      "barcode": barcode,
    };
  }
}
