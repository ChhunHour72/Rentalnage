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

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'joinDate': joinDate,
    };
  }
}
