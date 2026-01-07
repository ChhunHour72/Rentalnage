import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../model/rental_model.dart';
import '../../data/initial_data.dart';

class CreateReceiptScreen extends StatefulWidget {
  const CreateReceiptScreen({super.key});

  @override
  State<CreateReceiptScreen> createState() => _CreateReceiptScreenState();
}

class _CreateReceiptScreenState extends State<CreateReceiptScreen> {
  List<Room> rooms = [];
  Room? selectedRoom;
  bool isLoading = true;
  
  TextEditingController roomCostController = TextEditingController(text: "100");
  TextEditingController waterCostController = TextEditingController();
  TextEditingController electricityCostController = TextEditingController();
  TextEditingController totalController = TextEditingController(text: "0");
  
  String durDate = "01 Dec, 2025";
  String endDate = "01 Jan, 2026";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    roomCostController.dispose();
    waterCostController.dispose();
    electricityCostController.dispose();
    totalController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      String jsonString = initialDataJson;
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> roomsJson = jsonData['rooms'];
      
      List<Room> tempRooms = [];
      for (int i = 0; i < roomsJson.length; i++) {
        Room room = Room.fromJson(roomsJson[i]);
        if (room.tenant != null) {
          tempRooms.add(room);
        }
      }
      
      setState(() {
        rooms = tempRooms;
        if (rooms.isNotEmpty) {
          selectedRoom = rooms[0];
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void calculateTotal() {
    double roomCost = double.tryParse(roomCostController.text) ?? 0;
    double waterCost = double.tryParse(waterCostController.text) ?? 0;
    double electricityCost = double.tryParse(electricityCostController.text) ?? 0;
    
    setState(() {
      totalController.text = (roomCost + waterCost + electricityCost).toStringAsFixed(0);
    });
  }

  void createReceipt() {
    if (selectedRoom == null) return;

    Receipt newReceipt = Receipt(
      roomCost: double.tryParse(roomCostController.text) ?? 0,
      waterCost: double.tryParse(waterCostController.text) ?? 0,
      electricityCost: double.tryParse(electricityCostController.text) ?? 0,
      durDate: durDate,
      endDate: endDate,
      isPaid: false,
      paymentStatus: "Unpaid",
    );

    setState(() {
      selectedRoom!.receipts.add(newReceipt);
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (rooms.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Create Receipt')),
        body: Center(child: Text('No rooms with tenants')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Receipt'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<Room>(
              value: selectedRoom,
              isExpanded: true,
              items: rooms.map((room) {
                return DropdownMenuItem(
                  value: room,
                  child: Text('Room ${room.roomNumber} - ${room.tenant?.name}'),
                );
              }).toList(),
              onChanged: (room) {
                setState(() {
                  selectedRoom = room;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: roomCostController,
              decoration: InputDecoration(labelText: 'Room Cost'),
              keyboardType: TextInputType.number,
              onChanged: (_) => calculateTotal(),
            ),
            SizedBox(height: 10),
            TextField(
              controller: waterCostController,
              decoration: InputDecoration(labelText: 'Water Cost'),
              keyboardType: TextInputType.number,
              onChanged: (_) => calculateTotal(),
            ),
            SizedBox(height: 10),
            TextField(
              controller: electricityCostController,
              decoration: InputDecoration(labelText: 'Electricity Cost'),
              keyboardType: TextInputType.number,
              onChanged: (_) => calculateTotal(),
            ),
            SizedBox(height: 10),
            TextField(
              controller: totalController,
              decoration: InputDecoration(labelText: 'Total'),
              enabled: false,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: createReceipt,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Create Receipt', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
