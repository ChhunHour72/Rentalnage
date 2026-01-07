import 'package:flutter/material.dart';
import '../../model/rental_model.dart';

// Widget to display guest/tenant information in a list
class GuestCard extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;

  const GuestCard({
    super.key,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get status color
    Color statusColor;
    String statusText = room.statusColor;

    if (statusText == "Unpaid") {
      statusColor = Colors.red.shade400;
    } else if (statusText == "Paid") {
      statusColor = Colors.purple.shade300;
    } else {
      statusColor = Colors.grey.shade400;
    }

    // Get avatar background color based on status
    Color avatarColor;
    if (statusText == "Unpaid") {
      avatarColor = Colors.red.shade100;
    } else if (statusText == "Paid") {
      avatarColor = Colors.purple.shade100;
    } else {
      avatarColor = Colors.grey.shade200;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [avatarColor, avatarColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    color: statusColor,
                    size: 26,
                  ),
                ),

                SizedBox(width: 14),

                // Name and room
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.tenant != null ? room.tenant!.name : 'No Tenant',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Room ${room.roomNumber}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
