import 'package:flutter/material.dart';
import '../../model/room.dart';
import '../../model/receipt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RoomDetailScreen extends StatefulWidget {
  final Room room;
  final VoidCallback onUpdate;
  final List<Room>? allRooms;

  const RoomDetailScreen({
    super.key,
    required this.room,
    required this.onUpdate,
    this.allRooms,
  });

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  void evictTenant() {
    setState(() {
      widget.room.tenant = null;
      widget.room.receipts.clear();
      widget.onUpdate();
    });
    Navigator.pop(context);
  }

  void togglePaymentStatus(Receipt receipt) async {
    // Determine the new status
    final newStatus = !receipt.isPaid;
    final newStatusText = newStatus ? 'Paid' : 'Unpaid';

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Status Change'),
          content: Text(
            'Are you sure you want to change the payment status to "$newStatusText"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: newStatus ? Colors.green : Colors.red,
              ),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );

    // If user confirmed, apply the change
    if (confirmed == true) {
      setState(() {
        receipt.isPaid = newStatus;
        receipt.paymentStatus = newStatusText;
        print('RoomDetail: Toggled payment status to $newStatusText');
      });

      // Save immediately after toggle
      if (widget.allRooms != null) {
        try {
          Map<String, dynamic> data = {
            'rooms': widget.allRooms!.map((room) => room.toJson()).toList(),
          };
          const encoder = JsonEncoder.withIndent('  ');
          String jsonString = encoder.convert(data);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('rooms_data', jsonString);
          print('RoomDetail: Data saved to SharedPreferences');
          print('RoomDetail: Updated receipt status: ${receipt.paymentStatus}');

          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Payment status changed to $newStatusText'),
                backgroundColor: newStatus ? Colors.green : Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          print('RoomDetail: Error saving: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error saving data: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.room.roomNumber}'),
        backgroundColor: Colors.red,
        actions: [
          if (widget.room.tenant != null)
            IconButton(icon: Icon(Icons.exit_to_app), onPressed: evictTenant),
        ],
      ),
      body: widget.room.tenant == null
          ? Center(child: Text('Room Available'))
          : Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tenant: ${widget.room.tenant!.name}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('Phone: ${widget.room.tenant!.phone}'),
                  Text('Join Date: ${widget.room.tenant!.joinDate}'),
                  SizedBox(height: 20),
                  Text(
                    'Receipts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: widget.room.receipts.isEmpty
                        ? Center(child: Text('No receipts'))
                        : ListView.builder(
                            itemCount: widget.room.receipts.length,
                            itemBuilder: (context, index) {
                              Receipt receipt = widget.room.receipts[index];
                              return Card(
                                child: ListTile(
                                  title: Text('Total: \$${receipt.totalCost}'),
                                  subtitle: Text(
                                    '${receipt.durDate} - ${receipt.endDate}',
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () => togglePaymentStatus(receipt),
                                    child: Chip(
                                      label: Text(receipt.paymentStatus),
                                      backgroundColor: receipt.isPaid
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
