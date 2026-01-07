import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/room.dart';
import '../../../data/initial_data.dart';
import '../../widget/tenant_card.dart';
import '../create_receipt_screen.dart';

class PaymentsTab extends StatefulWidget {
  const PaymentsTab({super.key});

  @override
  State<PaymentsTab> createState() => PaymentsTabState();
}

class PaymentsTabState extends State<PaymentsTab> {
  List<Room> allRooms = [];
  List<Room> displayedRooms = [];
  bool isLoading = true;
  String currentFilter = "All";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      // Load from SharedPreferences to get latest data including evictions
      final prefs = await SharedPreferences.getInstance();
      String? savedData = prefs.getString('rooms_data');
      
      String jsonString = savedData ?? initialDataJson;
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> roomsJson = jsonData['rooms'];
      
      List<Room> tempRooms = [];
      for (int i = 0; i < roomsJson.length; i++) {
        Room room = Room.fromJson(roomsJson[i]);
        // Only add rooms with tenants
        if (room.tenant != null) {
          tempRooms.add(room);
        }
      }
      
      if (mounted) {
        setState(() {
          allRooms = tempRooms;
          // Apply current filter
          if (currentFilter == "All") {
            displayedRooms = tempRooms;
          } else {
            displayedRooms = tempRooms.where((r) => r.statusColor == currentFilter).toList();
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          allRooms = [];
          displayedRooms = [];
          isLoading = false;
        });
      }
    }
  }

  void filterRooms(String filter) {
    if (!mounted) return;
    
    setState(() {
      currentFilter = filter;
      
      // Filter logic: "All" shows all occupied rooms,
      // specific filters show only rooms matching that payment status
      if (filter == "All") {
        // Show all rooms with tenants (already filtered in loadData)
        displayedRooms = allRooms;
      } else {
        // Filter by payment status
        List<Room> filteredList = [];
        for (int i = 0; i < allRooms.length; i++) {
          if (allRooms[i].statusColor == filter) {
            filteredList.add(allRooms[i]);
          }
        }
        displayedRooms = filteredList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilterButton(
                        label: "All",
                        isSelected: currentFilter == "All",
                        onTap: () => filterRooms("All"),
                      ),
                      FilterButton(
                        label: "Paid",
                        isSelected: currentFilter == "Paid",
                        onTap: () => filterRooms("Paid"),
                      ),
                      FilterButton(
                        label: "Unpaid",
                        isSelected: currentFilter == "Unpaid",
                        onTap: () => filterRooms("Unpaid"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: displayedRooms.isEmpty
                      ? Center(child: Text('No payments found'))
                      : ListView.builder(
                          itemCount: displayedRooms.length,
                          itemBuilder: (context, index) {
                            Room room = displayedRooms[index];
                            
                            return TenantCard(
                              room: room,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateReceiptScreen(initialRoom: room),
                                  ),
                                );
                                // Reload data after returning from create receipt screen
                                loadData();
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = label == "Paid" ? Colors.purple : Colors.red;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
