import 'package:flutter/material.dart';
import '../../model/room.dart';
import '../../model/receipt.dart';
import '../../model/tenant.dart';
import '../widget/custom_text_field.dart';
import '../widget/receipt_card_widget.dart';
import '../widget/empty_room_widget.dart';
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void showAddTenantDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Tenant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: nameController,
                labelText: 'Tenant Name',
                icon: Icons.person,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: phoneController,
                labelText: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  setState(() {
                    widget.room.tenant = Tenant(
                      name: nameController.text,
                      phone: phoneController.text,
                      joinDate: DateTime.now().toString().split(' ')[0],
                    );
                  });
                  
                  if (widget.allRooms != null) {
                    try {
                      Map<String, dynamic> data = {
                        'rooms': widget.allRooms!.map((room) => room.toJson()).toList(),
                      };
                      String jsonString = json.encode(data);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('rooms_data', jsonString);
                    } catch (e) {
                      print('Error saving tenant: $e');
                    }
                  }
                  
                  widget.onUpdate();
                  nameController.clear();
                  phoneController.clear();
                  Navigator.pop(context);
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tenant added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void evictTenant() {
    setState(() {
      widget.room.tenant = null;
      widget.room.receipts.clear();
      widget.onUpdate();
    });
    Navigator.pop(context);
  }

  void showEditReceiptDialog(Receipt receipt) {
    final roomCostController = TextEditingController(text: receipt.roomCost.toString());
    final waterCostController = TextEditingController(text: receipt.waterCost.toString());
    final electricCostController = TextEditingController(text: receipt.electricityCost.toString());
    String startDate = receipt.durDate;
    String endDate = receipt.endDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Edit Receipt'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      controller: roomCostController,
                      labelText: 'Room Cost',
                      icon: Icons.home,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 12),
                    CustomTextField(
                      controller: waterCostController,
                      labelText: 'Water Cost',
                      icon: Icons.water_drop,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 12),
                    CustomTextField(
                      controller: electricCostController,
                      labelText: 'Electricity Cost',
                      icon: Icons.electric_bolt,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            startDate = "${picked.day.toString().padLeft(2, '0')} ${_getMonthName(picked.month)}, ${picked.year}";
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(startDate),
                      ),
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(Duration(days: 30)),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            endDate = "${picked.day.toString().padLeft(2, '0')} ${_getMonthName(picked.month)}, ${picked.year}";
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.event),
                        ),
                        child: Text(endDate),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        receipt.roomCost = double.parse(roomCostController.text);
                        receipt.waterCost = double.parse(waterCostController.text);
                        receipt.electricityCost = double.parse(electricCostController.text);
                        receipt.durDate = startDate;
                        receipt.endDate = endDate;
                      });

                      if (widget.allRooms != null) {
                        Map<String, dynamic> data = {
                          'rooms': widget.allRooms!.map((room) => room.toJson()).toList(),
                        };
                        String jsonString = json.encode(data);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('rooms_data', jsonString);
                      }

                      widget.onUpdate();
                      Navigator.pop(context);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Receipt updated successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: Invalid input'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
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
    return WillPopScope(
      onWillPop: () async {
        widget.onUpdate(); // Refresh dashboard when going back
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Room ${widget.room.roomNumber}'),
          backgroundColor: Colors.red,
          actions: [
            if (widget.room.tenant != null)
              IconButton(icon: Icon(Icons.exit_to_app), onPressed: evictTenant),
          ],
        ),
        body: widget.room.tenant == null
          ? EmptyRoomWidget(onAddTenant: showAddTenantDialog)
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
                              return ReceiptCardWidget(
                                receipt: receipt,
                                onTogglePayment: () => togglePaymentStatus(receipt),
                                onEdit: () => showEditReceiptDialog(receipt),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
