import 'package:flutter/material.dart';

class ViewRoomsTab extends StatefulWidget {
  const ViewRoomsTab({super.key});

  @override
  State<ViewRoomsTab> createState() => _ViewRoomsTabState();
}

class _ViewRoomsTabState extends State<ViewRoomsTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Tab 3: View Rooms"));
  }
}