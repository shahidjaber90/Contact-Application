import 'package:contact_app/Utils/colors.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

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
  var currentTime = '';

  fetchTime() async {
    var timePicker =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (timePicker != null) {
      setState(() {
        currentTime = timePicker.format(context);
      });
    }
  }

  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContact();
    } else {
      await Permission.contacts.request();
    }
  }

  void fetchContact() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts;
      isLoading = false;
    });
    print(contacts);
  }

  @override
  void initState() {
    super.initState();
    getContactPermission();
    search.addListener(() {
      filterContacts();
      fetchTime();
    });
  }

  filterContacts() {
    // ignore: no_leading_underscores_for_local_identifiers
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (search.text.isNotEmpty) {
      _contacts.retainWhere((element) {
        String searchValue = search.text.toLowerCase();
        String contactName = element.displayName!.toLowerCase();
        return contactName.contains(searchValue);
      });
      setState(() {
        contactsFilter = _contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isSearching = search.text.isNotEmpty;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 249, 248, 237),
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  fetchTime();
                },
                child: Text(
                  currentTime,
                  style: GoogleFonts.vidaloka(
                    fontSize: 18,
                    letterSpacing: 1,
                    color: ColorConstant.textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ))
          ],
          leading: IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.density_medium_outlined,
                color: ColorConstant.iconColor),
          )),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: const Color.fromARGB(255, 249, 248, 237),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.07,
                width: screenWidth / 1.1,
                child: TextFormField(
                  controller: search,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide(color: ColorConstant.iconColor),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: ColorConstant.iconColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                      32,
                    )),
                    label: Text(
                      'Search Contact',
                      style: TextStyle(
                          letterSpacing: 0.5,
                          color: ColorConstant.textColor.withOpacity(0.50)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Help us to improve!',
                      style: GoogleFonts.vidaloka(
                        fontSize: 18,
                        letterSpacing: 1,
                        color: ColorConstant.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ColorConstant.linearStartColor,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: isSearching == true
                              ? contactsFilter.length
                              : contacts.length,
                          itemBuilder: (context, index) {
                            Contact contact = isSearching == true
                                ? contactsFilter[index]
                                : contacts[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 80,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      ColorConstant.linearStartColor,
                                      ColorConstant.linearEndColor
                                    ],
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    // ignore: avoid_print
                                    print(contacts[index].displayName);
                                  },
                                  leading: (contact.avatar != null &&
                                          contact.avatar!.isNotEmpty)
                                      ? CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              MemoryImage(contact.avatar!),
                                        )
                                      : CircleAvatar(
                                          radius: 30,
                                          child: Text(
                                            contact.initials(),
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          backgroundColor: ColorConstant
                                              .textColor
                                              .withOpacity(0.60),
                                        ),
                                  title: Wrap(children: [
                                    Text(
                                      contact.displayName!,
                                      style: GoogleFonts.vidaloka(
                                        fontSize: 19,
                                        letterSpacing: 1,
                                        color: ColorConstant.textColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      contact.phones![0].value!,
                                      style: GoogleFonts.vidaloka(
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ))
            ],
          ),
        ),
      ),
    ));
  }
}
