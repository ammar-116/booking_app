import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/manager_dashboard.dart';
import 'screens/map_screen.dart';
import 'screens/my_bookings_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signOut(); // Always start unauthenticated
  runApp(RoomBookingApp());
}

class RoomBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Raah-Sarae',
      theme: AppTheme.theme,
      routes: {
        '/login': (_) => LoginScreen(),
        '/home': (_) => MainShell(),
        '/manager': (_) => ManagerDashboard(),
      },
      home: MainShell(), // Always start at map, no auth check on launch
    );
  }
}

class MainShell extends StatefulWidget {
  final String? initialCity;
  const MainShell({super.key, this.initialCity});

  @override
  _MainShellState createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  String? _city;

  @override
  void initState() {
    super.initState();
    if (widget.initialCity != null) {
      _city = widget.initialCity;
      _currentIndex = 1; // Jump to Search tab if city was pre-selected
    }
  }

  void navigateToCity(String city) {
    setState(() {
      _city = city;
      _currentIndex = 1; // Switch to Search tab after tapping a city on map
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          MapScreen(onCityTap: navigateToCity),
          HomeScreen(city: _city),
          MyBookingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: "My Bookings",
          ),
        ],
      ),
    );
  }
}
