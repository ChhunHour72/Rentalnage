import 'package:flutter/material.dart';
import '../../model/receipt.dart';

class ReceiptCardWidget extends StatelessWidget {
  final Receipt receipt;
  final VoidCallback onTogglePayment;
  final VoidCallback onEdit;

  const ReceiptCardWidget({
    super.key,
    required this.receipt,
    required this.onTogglePayment,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(
          Icons.receipt_rounded,
          color: Colors.blue,
          size: 28,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${receipt.totalCost.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: onTogglePayment,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: receipt.isPaid
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      receipt.isPaid ? Icons.check_circle : Icons.pending,
                      size: 16,
                      color: receipt.isPaid
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                    SizedBox(width: 4),
                    Text(
                      receipt.paymentStatus.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: receipt.isPaid
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${receipt.durDate} to ${receipt.endDate}',
          style: TextStyle(fontSize: 12),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cost Breakdown:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCostDetail('Room', receipt.roomCost, Icons.home),
                    _buildCostDetail('Water', receipt.waterCost, Icons.water_drop),
                    _buildCostDetail('Electric', receipt.electricityCost, Icons.electric_bolt),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: onEdit,
                    icon: Icon(Icons.edit, size: 18),
                    label: Text('Edit Receipt'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostDetail(String label, double cost, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 28),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '\$${cost.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),
      ],
    );
  }
}
