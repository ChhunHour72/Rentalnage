import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../model/room.dart';
import '../../../data/initial_data.dart';

class TodayPaymentTab extends StatefulWidget {
  const TodayPaymentTab({super.key});

  @override
  State<TodayPaymentTab> createState() => _TodayPaymentTabState();
}

class _TodayPaymentTabState extends State<TodayPaymentTab> {
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
      String jsonString = initialDataJson;
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> roomsJson = jsonData['rooms'];
      
      List<Room> tempRooms = [];
      for (int i = 0; i < roomsJson.length; i++) {
        tempRooms.add(Room.fromJson(roomsJson[i]));
      }
      
      if (mounted) {
        setState(() {
          allRooms = tempRooms;
          displayedRooms = tempRooms;
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
      
      if (filter == "All") {
        List<Room> filteredList = [];
        for (int i = 0; i < allRooms.length; i++) {
          if (allRooms[i].tenant != null) {
            filteredList.add(allRooms[i]);
          }
        }
        displayedRooms = filteredList;
      } else {
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
                            String roomStatus = room.statusColor;
                            Color statusColor = roomStatus == "Unpaid" 
                                ? Colors.red 
                                : Colors.purple;
                            
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: statusColor,
                                  child: Text(room.roomNumber),
                                ),
                                title: Text(room.tenant?.name ?? 'No Tenant'),
                                subtitle: Text('Room ${room.roomNumber}'),
                                trailing: Chip(
                                  label: Text(roomStatus),
                                  backgroundColor: statusColor.withOpacity(0.2),
                                ),
                              ),
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
