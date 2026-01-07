import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../model/room.dart';
import '../../../data/initial_data.dart';
import '../../widget/statistics_card.dart';
import '../../widget/expense_card.dart';
import '../../widget/guest_card.dart';
import '../room_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => DashboardTabState();
}

class DashboardTabState extends State<DashboardTab> {
  List<Room> rooms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      // Using SharedPreferences to persist data across app restarts
      // This allows landlords to maintain their tenant data even after closing the app
      final prefs = await SharedPreferences.getInstance();
      String? savedData = prefs.getString('rooms_data');

      String jsonString;
      if (savedData != null) {
        jsonString = savedData;
      } else {
        jsonString = initialDataJson;
        await prefs.setString('rooms_data', jsonString);
      }

      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> roomsJson = jsonData['rooms'];
      List<Room> tempRooms = [];

      for (int i = 0; i < roomsJson.length; i++) {
        Room room = Room.fromJson(roomsJson[i]);
        tempRooms.add(room);
      }

      if (mounted) {
        setState(() {
          rooms = tempRooms;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          rooms = [];
          isLoading = false;
        });
      }
    }
  }

  Future<void> saveData() async {
    try {
      Map<String, dynamic> data = {
        'rooms': rooms.map((room) => room.toJson()).toList(),
      };

      const encoder = JsonEncoder.withIndent('  ');
      String jsonString = encoder.convert(data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('rooms_data', jsonString);
    } catch (e) {
      // Handle error silently or show user-friendly message
    }
  }

  int getTotalRooms() {
    return rooms.length;
  }

  int getUnpaidRooms() {
    int count = 0;
    for (int i = 0; i < rooms.length; i++) {
      if (rooms[i].statusColor == "Unpaid") {
        count = count + 1;
      }
    }
    return count;
  }

  int getAvailableRooms() {
    int count = 0;
    for (int i = 0; i < rooms.length; i++) {
      if (rooms[i].tenant == null) {
        count = count + 1;
      }
    }
    return count;
  }

  int getPaidRooms() {
    int count = 0;
    for (int i = 0; i < rooms.length; i++) {
      if (rooms[i].statusColor == "Paid") {
        count = count + 1;
      }
    }
    return count;
  }

  // Calculate total expenses
  double getTotalWaterCost() {
    double total = 0;
    for (int i = 0; i < rooms.length; i++) {
      for (int j = 0; j < rooms[i].receipts.length; j++) {
        total = total + rooms[i].receipts[j].waterCost;
      }
    }
    return total;
  }

  double getTotalElectricityCost() {
    double total = 0;
    for (int i = 0; i < rooms.length; i++) {
      for (int j = 0; j < rooms[i].receipts.length; j++) {
        total = total + rooms[i].receipts[j].electricityCost;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome header
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFF8F9FA)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF6B6B).withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFFFF6B6B).withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              color: Color(0xFFFF6B6B),
                              size: 26,
                            ),
                          ),
                        ),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              'Lebron',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Statistics card
                  StatisticsCard(
                    totalRooms: getTotalRooms(),
                    unpaidRooms: getUnpaidRooms(),
                    availableRooms: getAvailableRooms(),
                    paidRooms: getPaidRooms(),
                  ),

                  SizedBox(height: 24),

                  // Expense section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Expenses',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        Icon(Icons.more_horiz, color: Colors.grey.shade400),
                      ],
                    ),
                  ),

                  SizedBox(height: 14),

                  // Expense cards
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        ExpenseCard(
                          title: 'Water',
                          amount: getTotalWaterCost(),
                          color: Color(0xFF4FC3F7),
                          icon: Icons.water_drop_rounded,
                        ),
                        SizedBox(width: 14),
                        ExpenseCard(
                          title: 'Electricity',
                          amount: getTotalElectricityCost(),
                          color: Color(0xFFFFB74D),
                          icon: Icons.bolt,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 28),

                  // Guest section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tenants',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFF6B6B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add, color: Color(0xFFFF6B6B)),
                            onPressed: () {
                              showAssignTenantDialog();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 14),

                  // Guest list
                  rooms.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'No rooms data available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            Room currentRoom = rooms[index];

                            return GuestCard(
                              room: currentRoom,
                              onTap: () async {
                                // Navigate to detail screen
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RoomDetailScreen(
                                      room: currentRoom,
                                      allRooms: rooms,
                                      onUpdate: () {
                                        saveData();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                                // Reload data when coming back to ensure sync
                                loadData();
                              },
                            );
                          },
                        ),

                  SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  void showAssignTenantDialog() {
    // Filter for only empty rooms to show available options
    // This prevents accidentally trying to assign multiple tenants to the same room
    List<Room> emptyRooms = rooms.where((room) => room.tenant == null).toList();

    if (emptyRooms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All rooms are currently occupied'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Available Room'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: emptyRooms.length,
                    itemBuilder: (context, index) {
                      Room room = emptyRooms[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Text(
                              room.roomNumber,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text('Room ${room.roomNumber}'),
                          subtitle: Text('Available'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () async {
                            Navigator.pop(context);
                            // Navigate to room detail to assign tenant
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoomDetailScreen(
                                  room: room,
                                  onUpdate: () {
                                    saveData();
                                    loadData();
                                  },
                                  allRooms: rooms,
                                ),
                              ),
                            );
                            loadData();
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showCreateRoomDialog();
                  },
                  icon: Icon(Icons.add_home),
                  label: Text('Create New Room'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6B6B),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 45),
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
          ],
        );
      },
    );
  }

  void showCreateRoomDialog() {
    final roomNumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Room'),
          content: TextField(
            controller: roomNumberController,
            decoration: InputDecoration(
              labelText: 'Room Number',
              hintText: 'e.g., 11, 12, A1',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.door_front_door),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (roomNumberController.text.isNotEmpty) {
                  // Check if room number already exists
                  bool roomExists = rooms.any(
                    (room) => room.roomNumber == roomNumberController.text.trim(),
                  );

                  if (roomExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Room ${roomNumberController.text} already exists'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  // Create new room
                  Room newRoom = Room(
                    roomNumber: roomNumberController.text.trim(),
                    tenant: null,
                    receipts: [],
                  );

                  setState(() {
                    rooms.add(newRoom);
                  });

                  saveData();
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Room ${roomNumberController.text} created successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Optionally navigate to the new room to assign tenant immediately
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomDetailScreen(
                        room: newRoom,
                        onUpdate: () {
                          saveData();
                          loadData();
                        },
                        allRooms: rooms,
                      ),
                    ),
                  ).then((_) => loadData());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6B6B),
              ),
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
