// Receipt class represents a payment record
class Receipt {
  double roomCost;
  double waterCost;
  double electricityCost;
  String durDate; // Start date
  String endDate; // End date
  bool isPaid;
  String paymentStatus; // "Paid" or "Unpaid"

  Receipt({
    required this.roomCost,
    required this.waterCost,
    required this.electricityCost,
    required this.durDate,
    required this.endDate,
    required this.isPaid,
    required this.paymentStatus,
  });

  // Calculate total cost
  double get totalCost {
    return roomCost + waterCost + electricityCost;
  }

  // This function converts JSON data to a Receipt object
  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      roomCost: json['roomCost'].toDouble(),
      waterCost: json['waterCost'].toDouble(),
      electricityCost: json['electricityCost'].toDouble(),
      durDate: json['durDate'],
      endDate: json['endDate'],
      isPaid: json['isPaid'],
      paymentStatus: json['paymentStatus'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'roomCost': roomCost,
      'waterCost': waterCost,
      'electricityCost': electricityCost,
      'durDate': durDate,
      'endDate': endDate,
      'isPaid': isPaid,
      'paymentStatus': paymentStatus,
    };
  }
}
