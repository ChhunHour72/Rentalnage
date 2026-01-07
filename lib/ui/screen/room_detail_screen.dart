import 'package:flutter/material.dart';
import '../../model/room.dart';
import '../../model/receipt.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;
  final VoidCallback onUpdate;

  const RoomDetailScreen({
    super.key,
    required this.room,
    required this.onUpdate,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.room.roomNumber}'),
        backgroundColor: Colors.red,
        actions: [
          if (widget.room.tenant != null)
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: evictTenant,
            ),
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
                                  subtitle: Text('${receipt.durDate} - ${receipt.endDate}'),
                                  trailing: Chip(
                                    label: Text(receipt.paymentStatus),
                                    backgroundColor: receipt.isPaid 
                                        ? Colors.green.shade100 
                                        : Colors.red.shade100,
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
