import 'package:contact_app/Provider/Contact_view_provider.dart';
import 'package:contact_app/Screens/contact_profile_view.dart';
import 'package:contact_app/Utils/colors.dart';
import 'package:contact_app/Utils/local_variables.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MyContactsPage extends StatefulWidget {
  const MyContactsPage({super.key});

  @override
  State<MyContactsPage> createState() => _MyContactsPageState();
}

class _MyContactsPageState extends State<MyContactsPage> {
  bool isLoading = true;
  TextEditingController search = TextEditingController();
  var currentTime = '';

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
    if (contacts.isEmpty) {
      getContactPermission();
    } else {
      print('contacts is not empty');
      print(contacts);
    }
    search.addListener(() {
      filterContacts();
      // fetchTime();
    });
  }

  filterContacts() {
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
    List<Contact> profile = context.watch<ContactViewProvider>().profileContact;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isSearching = search.text.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Container(
        height: screenHeight,
        width: screenWidth,
        color: Colors.white,
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
                    filled: true,
                    fillColor: ColorConstant.silverGreyColor.withOpacity(0.30),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: ColorConstant.textColor,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ).copyWith(top: 10),
                child: Row(
                  children: [
                    Text(
                      'Help us to improve!',
                      style: GoogleFonts.glory(
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
                  child: isLoading && contacts.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ColorConstant.linearStartColor,
                          ),
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: isSearching == true
                              ? contactsFilter.length
                              : contacts.length,
                          itemBuilder: (context, index) {
                            Contact contact = isSearching == true
                                ? contactsFilter[index]
                                : contacts[index];
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 70,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  // gradient: LinearGradient(
                                  //   begin: Alignment.topLeft,
                                  //   end: Alignment.bottomRight,
                                  //   colors: [
                                  //     ColorConstant.linearStartColor,
                                  //     ColorConstant.linearEndColor
                                  //   ],
                                  // ),
                                ),
                                child: ListTile(
                                  onTap: () async {
                                    profile.clear();
                                    if (!profile.contains(contact)) {
                                      await context
                                          .read<ContactViewProvider>()
                                          .viewProfile(contact);
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContactProfile()));
                                      search.clear();
                                      print('profile:: $profile');
                                    }
                                    // ignore: avoid_print
                                    print(contacts[index].displayName);
                                  },
                                  leading: (contact.avatar != null &&
                                          contact.avatar!.isNotEmpty)
                                      ? CircleAvatar(
                                          radius: 24,
                                          backgroundImage:
                                              MemoryImage(contact.avatar!),
                                        )
                                      : CircleAvatar(
                                          radius: 24,
                                          // ignore: sort_child_properties_last
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
                                      style: GoogleFonts.glory(
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
                                      style: GoogleFonts.glory(
                                        fontSize: 16,
                                        letterSpacing: 1,
                                        color: ColorConstant.textColor,
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
    );
  }
}
