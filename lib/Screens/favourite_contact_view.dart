import 'package:contact_app/Provider/Contact_view_provider.dart';
import 'package:contact_app/Utils/colors.dart';
import 'package:contact_app/Utils/local_variables.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class FavouriteContactView extends StatefulWidget {
  const FavouriteContactView({super.key});

  @override
  State<FavouriteContactView> createState() => _FavouriteContactViewState();
}

class _FavouriteContactViewState extends State<FavouriteContactView> {
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
  List<Contact> favourite = context.watch<ContactViewProvider>().favouriteContact;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isSearching = search.text.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Container(
        height: screenHeight,
        width: screenWidth,
        color: ColorConstant.whiteColor,
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

              // list of data
              Expanded(child: ListView.builder(
          itemCount: favourite.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                (favourite[index].avatar != null &&
                        favourite[index].avatar!.isNotEmpty)
                    ? Container(
                        height: 280,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(favourite[index].avatar!),
                                fit: BoxFit.fill)))
                    : Container(
                        alignment: Alignment.center,
                        height: 150,
                        width: double.infinity,
                        child: CircleAvatar(
                          radius: 50,
                          child: Text(
                            favourite[index].initials(),
                            style: const TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        favourite[index].displayName!,
                        style: GoogleFonts.adamina(
                            letterSpacing: 1,
                            fontSize: 24,
                            color: ColorConstant.textColor),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),),
            ],
          ),
        ),
      ),
    );
  }
}
