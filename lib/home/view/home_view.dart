import 'package:provider/provider.dart';
import 'package:auth_service/auth_service.dart';
import 'package:trace_health/login/view/login_view.dart';
import 'package:trace_health/home/view/map_screen.dart';
import 'package:trace_health/home/view/user_screen.dart';
import 'package:trace_health/home/view/weight_screen.dart';
import 'package:trace_health/home/view/post_screen.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _pageList = [
    const MapScreen(),
    const UserScreen(),
    const WeightScreen(),
    PostScreen(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Trace Health Care'),
          backgroundColor: Colors.lightBlue,
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                await context.read<FirebaseAuthService>().signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ]),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Trace Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: 'Walking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Weight',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Post',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          _selectedIndex = index;

          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn);
        },
      ),
    );
  }
}
