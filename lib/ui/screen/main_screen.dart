import 'package:flutter/material.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/payments_tab.dart';
import 'create_receipt_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Variable to track which tab is currently selected
  int currentIndex = 0;
  final GlobalKey<DashboardTabState> dashboardKey = GlobalKey<DashboardTabState>();
  final GlobalKey<PaymentsTabState> paymentsKey = GlobalKey<PaymentsTabState>();

  // List of pages/tabs to display
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      DashboardTab(key: dashboardKey),
      PaymentsTab(key: paymentsKey),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      floatingActionButton: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateReceiptScreen(),
              ),
            );
            // Refresh dashboard and payments after creating receipt
            dashboardKey.currentState?.loadData();
            paymentsKey.currentState?.loadData();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.black,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        color: currentIndex == 0 ? Colors.red : Colors.grey.shade600,
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: currentIndex == 0 ? Colors.red : Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 80),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      currentIndex = 1;
                    });
                    // Reload payments tab when switching to it
                    paymentsKey.currentState?.loadData();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt,
                        color: currentIndex == 1 ? Colors.red : Colors.grey.shade600,
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Receipt',
                        style: TextStyle(
                          color: currentIndex == 1 ? Colors.red : Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}