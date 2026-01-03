class Payment {
  String id;
  double amount;
  DateTime date;
  String description;

  Payment({required this.id, required this.amount, required this.date, required this.description});
}

class Tenant {
  String name;
  String phone;
  List<Payment> payments; 

  Tenant({required this.name, required this.phone, required this.payments});
}

class Room {
  String roomNumber;
  double price;
  Tenant? currentTenant;

  Room({required this.roomNumber, required this.price, this.currentTenant});
}