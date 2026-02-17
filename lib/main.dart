import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/plant_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/plant_identification_screen.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('showOnboarding') ?? true;
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlantProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(showOnboarding: showOnboarding, isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  final bool isLoggedIn;

  MyApp({required this.showOnboarding, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final baseTextTheme = GoogleFonts.manropeTextTheme(
          themeProvider.currentTheme.textTheme,
        );
        final displayTextTheme = GoogleFonts.playfairDisplayTextTheme(
          themeProvider.currentTheme.textTheme,
        );

        return MaterialApp(
          title: 'Nexus Leafline',
          theme: themeProvider.currentTheme.copyWith(
            textTheme: baseTextTheme.copyWith(
              displayLarge: displayTextTheme.displayLarge,
              displayMedium: displayTextTheme.displayMedium,
              displaySmall: displayTextTheme.displaySmall,
              headlineLarge: displayTextTheme.headlineLarge,
              headlineMedium: displayTextTheme.headlineMedium,
              headlineSmall: displayTextTheme.headlineSmall,
              titleLarge: displayTextTheme.titleLarge,
              titleMedium: displayTextTheme.titleMedium,
              titleSmall: displayTextTheme.titleSmall,
            ),
          ),
          home: isLoggedIn
              ? MainScreen()
              : LoginScreen(showOnboarding: showOnboarding),
          routes: {
            '/home': (context) => MainScreen(),
            '/plant_identification': (context) => PlantIdentificationScreen(),
          },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    RemindersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Reminders',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
            ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.eco, size: 40, color: Colors.green),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nexus Leafline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Plant Care Made Easy',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 0);
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 1);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 2);
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Reminders'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 3);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Identify Plant'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/plant_identification');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Nexus Leafline',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2026 Nexus Leafline',
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('is_logged_in', false);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(showOnboarding: false),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
