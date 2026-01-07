import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../model/rental_model.dart';
import '../../../data/initial_data.dart';
import '../../widget/tenant_card.dart';
import '../room_detail_screen.dart';

class ViewRoomsTab extends StatefulWidget {
  const ViewRoomsTab({super.key});

  @override
  State<ViewRoomsTab> createState() => _ViewRoomsTabState();
}

class _ViewRoomsTabState extends State<ViewRoomsTab> {
  // List to store all rooms
  List<Room> allRooms = [];
  // List to store filtered rooms
  List<Room> displayedRooms = [];
  // Variable to track if data is still loading
  bool isLoading = true;
  // Variable to track current filter (All, Paid, Unpaid)
  String currentFilter = "All";

  @override
  void initState() {
    super.initState();
    // Load data when screen opens
    loadData();
  }

  // Function to read JSON file and parse it
  Future<void> loadData() async {
    try {
      // Get the JSON data from the data file
      String jsonString = initialDataJson;
      
      // Convert JSON string to Map
      Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Get the rooms array from JSON
      List<dynamic> roomsJson = jsonData['rooms'];
      
      // Create a temporary list to store Room objects
      List<Room> tempRooms = [];
      
      // Loop through each room in JSON and convert to Room object
      for (int i = 0; i < roomsJson.length; i++) {
        Room room = Room.fromJson(roomsJson[i]);
        tempRooms.add(room);
      }
      
      // Update the state with loaded rooms
      setState(() {
        allRooms = tempRooms;
        displayedRooms = tempRooms;
        isLoading = false;
      });
    } catch (e) {
      // If there's an error, print it and stop loading
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to filter rooms based on status
  void filterRooms(String filter) {
    setState(() {
      currentFilter = filter;
      
      if (filter == "All") {
        // Show all rooms
        displayedRooms = allRooms;
      } else {
        // Create empty list for filtered results
        List<Room> filteredList = [];
        
        // Loop through all rooms and add matching ones
        for (int i = 0; i < allRooms.length; i++) {
          if (allRooms[i].status == filter) {
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
        title: Text('View Rooms'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // All button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      filterRooms("All");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentFilter == "All" 
                          ? Colors.blue 
                          : Colors.grey.shade300,
                      foregroundColor: currentFilter == "All" 
                          ? Colors.white 
                          : Colors.black,
                    ),
                    child: Text('All'),
                  ),
                ),
                
                SizedBox(width: 8),
                
                // Paid button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      filterRooms("Paid");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentFilter == "Paid" 
                          ? Colors.green 
                          : Colors.grey.shade300,
                      foregroundColor: currentFilter == "Paid" 
                          ? Colors.white 
                          : Colors.black,
                    ),
                    child: Text('Paid'),
                  ),
                ),
                
                SizedBox(width: 8),
                
                // Unpaid button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      filterRooms("Unpaid");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentFilter == "Unpaid" 
                          ? Colors.red 
                          : Colors.grey.shade300,
                      foregroundColor: currentFilter == "Unpaid" 
                          ? Colors.white 
                          : Colors.black,
                    ),
                    child: Text('Unpaid'),
                  ),
                ),
              ],
            ),
          ),
          
          // Room list
          Expanded(
            child: isLoading
                ? Center(
                    // Show loading indicator while data is loading
                    child: CircularProgressIndicator(),
                  )
                : displayedRooms.isEmpty
                    ? Center(
                        // Show message if no rooms match filter
                        child: Text('No rooms found'),
                      )
                    : ListView.builder(
                        // Build list of room cards
                        itemCount: displayedRooms.length,
                        itemBuilder: (context, index) {
                          Room currentRoom = displayedRooms[index];
                          
                          return TenantCard(
                            room: currentRoom,
                            onTap: () {
                              // Navigate to detail screen when card is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RoomDetailScreen(
                                    room: currentRoom,
                                    onUpdate: () {
                                      // Reload data when returning from detail screen
                                      loadData();
                                    },
                                  ),
                                ),
                              );
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