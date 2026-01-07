// Tenant class represents a person renting a room
class Tenant {
  String name;
  String phone;
  String joinDate;

  Tenant({
    required this.name, 
    required this.phone, 
    required this.joinDate
  });

  // This function converts JSON data to a Tenant object
  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      name: json['name'],
      phone: json['phone'],
      joinDate: json['joinDate'],
    );
  }
}

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

// Room class represents a rental room
class Room {
  String roomNumber;
  Tenant? tenant;
  List<Receipt> receipts;

  Room({
    required this.roomNumber, 
    this.tenant, 
    required this.receipts
  });

  // This function converts JSON data to a Room object
  factory Room.fromJson(Map<String, dynamic> json) {
    // Create list of receipts from JSON array
    List<Receipt> receiptList = [];
    if (json['receipts'] != null) {
      for (var receiptJson in json['receipts']) {
        receiptList.add(Receipt.fromJson(receiptJson));
      }
    }

    // Create tenant object if it exists in JSON
    Tenant? tenantObj;
    if (json['tenant'] != null) {
      tenantObj = Tenant.fromJson(json['tenant']);
    }

    return Room(
      roomNumber: json['roomNumber'],
      tenant: tenantObj,
      receipts: receiptList,
    );
  }

  // This function checks the status of the room
  String get status {
    // If there is no tenant, room is empty
    if (tenant == null) {
      return "Available";
    }

    // Loop through all receipts to check payment status
    for (int i = 0; i < receipts.length; i++) {
      if (receipts[i].paymentStatus == "Unpaid") {
        return "Unpaid";
      }
    }

    // If all receipts are paid, return Paid
    return "Paid";
  }

  // Get status color based on room status
  String get statusColor {
    if (tenant == null) {
      return "Available";
    }
    
    for (int i = 0; i < receipts.length; i++) {
      if (receipts[i].paymentStatus == "Unpaid") {
        return "Unpaid";
      }
    }
    
    return "Paid";
  }
}