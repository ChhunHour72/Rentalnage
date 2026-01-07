import 'tenant.dart';
import 'receipt.dart';

class Room {
  String roomNumber;
  Tenant? tenant;
  List<Receipt> receipts;

  Room({
    required this.roomNumber, 
    this.tenant, 
    required this.receipts
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    List<Receipt> receiptList = [];
    if (json['receipts'] != null) {
      for (var receiptJson in json['receipts']) {
        receiptList.add(Receipt.fromJson(receiptJson));
      }
    }

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

  Map<String, dynamic> toJson() {
    return {
      'roomNumber': roomNumber,
      'tenant': tenant?.toJson(),
      'receipts': receipts.map((r) => r.toJson()).toList(),
    };
  }

  String get status {
    if (tenant == null) return "Available";
    
    for (var receipt in receipts) {
      if (receipt.paymentStatus == "Unpaid") return "Unpaid";
    }
    
    return "Paid";
  }

  String get statusColor {
    if (tenant == null) return "Available";
    
    for (var receipt in receipts) {
      if (receipt.paymentStatus == "Unpaid") return "Unpaid";
    }
    
    return "Paid";
  }
}
