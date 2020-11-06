import 'package:flutter/material.dart';

import 'package:tk/screens/toon_table.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const _navLabels = ["웹툰", "단행본", "망가", "포토툰", "마이페이지"];
  static const _navIcons = [
    Icon(Icons.all_inbox),
    Icon(Icons.article),
    Icon(Icons.backup_table),
    Icon(Icons.camera_alt),
    Icon(Icons.account_circle),
  ];
  List<BottomNavigationBarItem> _navItems = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 5; i++)
      _navItems.add(BottomNavigationBarItem(
        icon: _navIcons[i],
        label: _navLabels[i],
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ToonTable(_navLabels.elementAt(_selectedIndex)),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.black12,
      items: _navItems,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
