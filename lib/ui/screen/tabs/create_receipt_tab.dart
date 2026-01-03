import 'package:flutter/material.dart';

class CreateReceiptTab extends StatefulWidget {
  const CreateReceiptTab({super.key});

  @override
  State<CreateReceiptTab> createState() => _CreateReceiptTabState();
}

class _CreateReceiptTabState extends State<CreateReceiptTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Tab 2: Create Receipt"));
  }
}