class BillItem {
  String name;
  double mrp;
  int quantity;
  String barcode;

  BillItem({
    required this.name,
    required this.mrp,
    required this.quantity,
    required this.barcode,
  });

  /// ✅ Convert Firestore document to `BillItem` object
  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      name: json['name'] ?? '',
      mrp: (json['mrp'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      barcode: json['barcode'] ?? '',
    );
  }

  /// ✅ Convert `BillItem` object to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "mrp": mrp,
      "quantity": quantity,
      "barcode": barcode,
    };
  }
}
