import 'package:call_log/call_log.dart';
import 'package:contact_app/Provider/Contact_view_provider.dart';
import 'package:contact_app/Utils/colors.dart';
import 'package:contact_app/Utils/local_variables.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CallLogsView extends StatefulWidget {
  const CallLogsView({super.key});

  @override
  State<CallLogsView> createState() => _CallLogsViewState();
}

class _CallLogsViewState extends State<CallLogsView>
    with WidgetsBindingObserver {
  ContactViewProvider call1 = ContactViewProvider();

  late AppLifecycleState _notification;
  Future<Iterable<CallLogEntry>>? logs;
  Map<String, Uint8List?> avatarMap = {};
  Set<String> processedPhoneNumbers = {};

  Future<void> getCallLogsAndAvatars() async {
    Iterable<CallLogEntry> callLogs = await CallLog.get();
    Iterable<Contact> contacts = await ContactsService.getContacts(
      withThumbnails: true,
    );

    for (var callLog in callLogs) {
      String phoneNumber = callLog.formattedNumber!;
      // Skip if the phone number has already been processed
      if (processedPhoneNumbers.contains(phoneNumber)) {
        continue;
      }

      Contact matchingContact = contacts.firstWhere(
        (contact) =>
            {contact.phones![0].value}.any((phone) => phone == phoneNumber),
        orElse: () => null!,
      );

      if (matchingContact != null) {
        // Access the avatar of the matching contact
        Uint8List? avatarBytes = matchingContact.avatar;
        if (avatarBytes != null) {
          setState(() {
            // Store the avatar in the map with the corresponding phone number
            avatarMap[phoneNumber] = avatarBytes;
          });
        }
      }
      // Add the phone number to the processed set
      processedPhoneNumbers.add(phoneNumber);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = call1.getCallLogs();
    getCallLogsAndAvatars();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (AppLifecycleState.resumed == state) {
      setState(() {
        logs = call1.getCallLogs();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Contact> profile = context.watch<ContactViewProvider>().profileContact;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: getCallLogsAndAvatars, icon: Icon(Icons.data_usage)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Column(
          children: [
            FutureBuilder(
                future: logs,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Iterable<CallLogEntry> callLog = snapshot.data;
                    return Expanded(child: ListView.builder(
                      itemBuilder: (context, index) {
                        CallLogEntry callLogEntry = callLog.elementAt(index);
                        String phoneNumber = callLogEntry.formattedNumber!;
                        Uint8List? avatarBytes = avatarMap[phoneNumber];
                        return GestureDetector(
                          child: Card(
                            child: ListTile(
                                // avatar
                                leading: avatarBytes != null
                                    ? CircleAvatar(
                                        radius: 24,
                                        backgroundImage:
                                            MemoryImage(avatarBytes),
                                      )
                                    : CircleAvatar(
                                        radius: 24,
                                        child: Text(
                                          callLogEntry.name![0],
                                        ),
                                      ),
                                // title
                                title: call1.getTitle(callLog.elementAt(index)),

                                // subTitle time

                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Column(
                                    children: [
                                      CallType == 'missed'
                                          ? Row(
                                              children: [
                                                call1.getIcons(callLog
                                                    .elementAt(index)
                                                    .callType!),
                                                const SizedBox(width: 5),
                                                Text(
                                                  'Mobile',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.red.shade800,
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(width: 5),
                                                Icon(
                                                  Icons.circle_sharp,
                                                  size: 6,
                                                  color: Colors.red.shade800,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  call1.formatTimestamp(callLog
                                                      .elementAt(index)
                                                      .timestamp!
                                                      .toString()),
                                                  style: TextStyle(
                                                      color:
                                                          Colors.red.shade800),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                call1.getIcons(callLog
                                                    .elementAt(index)
                                                    .callType!),
                                                const SizedBox(width: 5),
                                                Text(
                                                  'Mobile',
                                                  style: TextStyle(
                                                      color: ColorConstant
                                                          .textColor,
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(width: 5),
                                                Icon(
                                                  Icons.circle_sharp,
                                                  size: 6,
                                                  color:
                                                      ColorConstant.textColor,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  call1.formatTimestamp(callLog
                                                      .elementAt(index)
                                                      .timestamp!
                                                      .toString()),
                                                  style: TextStyle(
                                                      color: ColorConstant
                                                          .textColor),
                                                ),
                                              ],
                                            ),
                                      //
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          callLog
                                                      .elementAt(index)
                                                      .phoneAccountId! ==
                                                  '1'
                                              ? Text(
                                                  callLog
                                                      .elementAt(index)
                                                      .simDisplayName!,
                                                  style: TextStyle(
                                                      color: ColorConstant
                                                          .textColor),
                                                )
                                              : Text(
                                                  'Telenor',
                                                  style: TextStyle(
                                                      color: ColorConstant
                                                          .textColor),
                                                ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),

                                // call icon
                                trailing: IconButton(
                                    icon: const Icon(Icons.phone_outlined),
                                    color: ColorConstant.textColor,
                                    onPressed: () {
                                      call1.makeCall(
                                          callLog.elementAt(index).number!);
                                    })),
                          ),
                        );
                      },
                    ));
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            color: ColorConstant.linearEndColor,
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
