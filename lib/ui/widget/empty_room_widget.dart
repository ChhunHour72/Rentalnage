import 'package:flutter/material.dart';

class EmptyRoomWidget extends StatelessWidget {
  final VoidCallback onAddTenant;

  const EmptyRoomWidget({
    super.key,
    required this.onAddTenant,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Room Available',
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAddTenant,
            icon: Icon(Icons.person_add),
            label: Text('Assign Tenant'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}
