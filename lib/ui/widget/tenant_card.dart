import 'package:flutter/material.dart';
import '../../model/room.dart';

// This is a reusable widget that displays room information
class TenantCard extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;

  const TenantCard({
    super.key,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get the status of the room (Empty, Paid, or Unpaid)
    String roomStatus = room.status;

    // Choose color based on status
    Color statusColor;
    if (roomStatus == "Empty") {
      statusColor = Colors.grey;
    } else if (roomStatus == "Unpaid") {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.green;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Room icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.door_front_door,
                  color: Colors.blue,
                  size: 30,
                ),
              ),

              SizedBox(width: 16),

              // Room information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room number
                    Text(
                      'Room ${room.roomNumber}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4),

                    // Tenant name or "No Tenant"
                    Text(
                      room.tenant != null ? room.tenant!.name : 'No Tenant',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              // Status pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  roomStatus,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
