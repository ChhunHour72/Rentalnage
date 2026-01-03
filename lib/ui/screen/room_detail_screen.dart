import 'package:flutter/material.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({super.key});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Room Details")),
      body: Center(
        child: Column(
          children: const [
            SizedBox(height: 20),
            Icon(Icons.home, size: 100, color: Colors.blue),
            Text("Room 101", style: TextStyle(fontSize: 30)),
            Text("Tenant: Sok Dara"),
          ],
        ),
      ),
    );
  }
}