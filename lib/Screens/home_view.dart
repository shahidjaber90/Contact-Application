import 'package:contact_app/Provider/Contact_view_provider.dart';
import 'package:contact_app/Screens/call_logs_view.dart';
import 'package:contact_app/Screens/favourite_contact_view.dart';
import 'package:contact_app/Utils/colors.dart';
import 'package:contact_app/Widgets/Contacts%20Pages/my_contacts_page.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Contact> contacts = [];
  List<Contact> contactsFilter = [];
  bool isLoading = true;
  TextEditingController search = TextEditingController();
  PageController _pageController = PageController();
  var currentTime = '';
  int _selectedIndex = 1;

  List<Widget> myPages = <Widget>[
    const FavouriteContactView(),
    const CallLogsView(),
    const MyContactsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Contact> profile = context.watch<ContactViewProvider>().profileContact;
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      body: Container(
        child: myPages.elementAt(_selectedIndex),
      ),
      // bottom navigation bar

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        selectedIconTheme: const IconThemeData(
          color: Colors.black,
          size: 26,
        ),
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 15, letterSpacing: 0.5),
        backgroundColor: ColorConstant.silverGreyColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: LineIcon(Icons.access_time_outlined),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_sharp),
            label: 'Contacts',
          ),
        ],
      ),
    );
  }
}
