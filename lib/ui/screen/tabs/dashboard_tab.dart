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
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  List<Room> rooms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      print('DashboardTab: Starting to load data...');

      final prefs = await SharedPreferences.getInstance();
      String? savedData = prefs.getString('rooms_data');

      String jsonString;
      if (savedData != null) {
        jsonString = savedData;
        print('DashboardTab: Loaded from SharedPreferences');
      } else {
        jsonString = initialDataJson;
        await prefs.setString('rooms_data', jsonString);
        print('DashboardTab: Initialized with default data');
      }

      print('DashboardTab: Parsing JSON...');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> roomsJson = jsonData['rooms'];
      List<Room> tempRooms = [];

      for (int i = 0; i < roomsJson.length; i++) {
        Room room = Room.fromJson(roomsJson[i]);
        tempRooms.add(room);
      }

      print('DashboardTab: Loaded ${tempRooms.length} rooms');
      if (mounted) {
        setState(() {
          rooms = tempRooms;
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error loading data: $e');
      print('Stack trace: $stackTrace');
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
      print('DashboardTab: Saving data...');

      Map<String, dynamic> data = {
        'rooms': rooms.map((room) => room.toJson()).toList(),
      };

      const encoder = JsonEncoder.withIndent('  ');
      String jsonString = encoder.convert(data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('rooms_data', jsonString);
      print('DashboardTab: Data saved to SharedPreferences');
      print(
        'DashboardTab: Saved data: ${jsonString.substring(0, jsonString.length > 200 ? 200 : jsonString.length)}...',
      );
    } catch (e, stackTrace) {
      print('Error saving data: $e');
      print('Stack trace: $stackTrace');
    }
  }

  // Calculate statistics
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
                            onPressed: () {},
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
}
