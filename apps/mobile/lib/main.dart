import 'package:flutter/material.dart'; 
import 'screens/today_screen.dart'; 
import 'screens/history_screen.dart'; 
import 'screens/community_screen.dart'; 
import 'screens/reflect_screen.dart'; 
import 'screens/profile_screen.dart'; 
 
void main() { runApp(const YijingApp()); } 
 
class YijingApp extends StatelessWidget { 
  const YijingApp({super.key}); 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp(title: 'Daily I Ching', theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo), home: const MainShell(), debugShowCheckedModeBanner: false); 
  } 
} 
 
class MainShell extends StatefulWidget { const MainShell({super.key}); @override State<MainShell> createState() => _MainShellState(); } 
 
class _MainShellState extends State<MainShell> { int _idx = 0; 
  final _screens = [const TodayScreen(), const HistoryScreen(), const CommunityScreen(), const ReflectScreen(), const ProfileScreen()]; 
  @override Widget build(BuildContext c) { return Scaffold(body: _screens[_idx], bottomNavigationBar: NavigationBar(selectedIndex: _idx, onDestinationSelected: (i) => setState(() => _idx = i), destinations: const [NavigationDestination(icon: Icon(Icons.wb_sunny_outlined), label: 'Today'), NavigationDestination(icon: Icon(Icons.history), label: 'History'), NavigationDestination(icon: Icon(Icons.people_outline), label: 'Community'), NavigationDestination(icon: Icon(Icons.self_improvement), label: 'Reflect'), NavigationDestination(icon: Icon(Icons.person_outline), label: 'Me')])); } } 
