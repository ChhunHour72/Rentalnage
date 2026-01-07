import 'package:flutter/material.dart';

// Widget to display room statistics - now interactive
class StatisticsCard extends StatelessWidget {
  final int totalRooms;
  final int unpaidRooms;
  final int availableRooms;
  final int paidRooms;
  final VoidCallback? onTap;

  const StatisticsCard({
    super.key,
    required this.totalRooms,
    required this.unpaidRooms,
    required this.availableRooms,
    required this.paidRooms,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.home_rounded,
                  label: 'All Rooms',
                  value: totalRooms.toString(),
                ),
                _buildStatItem(
                  icon: Icons.close_rounded,
                  label: 'Unpaid',
                  value: unpaidRooms.toString(),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
            SizedBox(height: 16),

            // Bottom row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.meeting_room_outlined,
                  label: 'Available',
                  value: availableRooms.toString(),
                ),
                
                // Paid percentage with circular indicator
                Container(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: totalRooms > 0 ? paidRooms / totalRooms : 0,
                          strokeWidth: 6,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${totalRooms > 0 ? (paidRooms / totalRooms * 100).toInt() : 0}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Completion',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
