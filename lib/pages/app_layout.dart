import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/widgets/loading_switch.dart';

class NavigationItem {
  const NavigationItem({
    required this.child,
    required this.icon,
    required this.label,
  });

  final String label;
  final Widget icon;
  final Widget child;
}

class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentPageIndex = 0;
  bool _isLoading = true;

  late UserProvider userProvider;
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      label: "",
      icon: const Icon(Icons.home),
      child: Container(),
    ),
    NavigationItem(
      label: "",
      icon: const Icon(Icons.search),
      child: Container(),
    ),
    NavigationItem(
      label: "",
      icon: const Icon(Icons.add_box_outlined),
      child: Container(),
    ),
    NavigationItem(
      label: "",
      icon: const Icon(Icons.shopping_bag_outlined),
      child: Container(),
    ),
    NavigationItem(
      label: "",
      icon: const Icon(Icons.account_circle),
      child: Container(),
    ),
  ];

  void _update() async {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.updateCurrentUser();
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingSwitch(
      isLoading: _isLoading,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: _navigationItems
              .map(
                (e) => BottomNavigationBarItem(icon: e.icon, label: e.label),
              )
              .toList(),
          onTap: (index) {
            setState(() => _currentPageIndex = index);
          },
        ),
        body: _navigationItems.elementAt(_currentPageIndex).child,
      ),
    );
  }
}
