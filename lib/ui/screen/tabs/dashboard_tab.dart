import 'package:flutter/material.dart';
import '../room_detail_screen.dart'; 

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});
  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: ListView( 
        children: [
          ListTile(
            leading: const Icon(Icons.door_front_door, color: Colors.red),
            title: const Text("Room 101 (Occupied)"),
            subtitle: const Text("Tap for details"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RoomDetailScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.door_front_door, color: Colors.green),
            title: const Text("Room 102 (Empty)"),
            onTap: () {
               
            },
          ),
        ],
      ),
    );
  }
}