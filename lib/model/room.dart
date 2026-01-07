import 'tenant.dart';
import 'receipt.dart';

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

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'roomNumber': roomNumber,
      'tenant': tenant?.toJson(),
      'receipts': receipts.map((r) => r.toJson()).toList(),
    };
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
