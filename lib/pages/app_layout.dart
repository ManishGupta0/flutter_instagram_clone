import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/widgets/loading_switch.dart';
import 'package:flutter_instagram_clone/widgets/custom_page_route.dart';
import 'package:flutter_instagram_clone/pages/feed_page.dart';
import 'package:flutter_instagram_clone/pages/search_page.dart';
import 'package:flutter_instagram_clone/pages/shop_page.dart';
import 'package:flutter_instagram_clone/pages/account_page.dart';
import 'package:flutter_instagram_clone/pages/add_page_layout.dart';

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
    const NavigationItem(
      label: "",
      icon: Icon(Icons.home),
      child: FeedPage(),
    ),
    const NavigationItem(
      label: "",
      icon: Icon(Icons.search),
      child: SearchPage(),
    ),
    const NavigationItem(
      label: "",
      icon: Icon(Icons.add_box_outlined),
      child: SizedBox(),
    ),
    const NavigationItem(
      label: "",
      icon: Icon(Icons.shopping_bag_outlined),
      child: ShopPage(),
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

    _navigationItems.last = NavigationItem(
      label: "",
      icon: const Icon(Icons.account_circle),
      child: AccountPage(user: userProvider.getUser),
    );

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
            if (index == 2) {
              Navigator.push(
                context,
                CustomPageRoute.fromLeft(
                  child: const AddPageLayout(),
                ),
              );
            } else {
              setState(() => _currentPageIndex = index);
            }
          },
        ),
        body: _navigationItems.elementAt(_currentPageIndex).child,
      ),
    );
  }
}
