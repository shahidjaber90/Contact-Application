import 'package:call_log/call_log.dart';
import 'package:contact_app/Utils/colors.dart';
import 'package:contact_app/Utils/local_variables.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactViewProvider with ChangeNotifier {
  List<Contact> profileContact = [];
  List<Contact> favouriteContact = [];

  // view contact profile
  viewProfile(index) {
    profileContact.add(index);
    notifyListeners();
  }

  // favourite contacts
  favouriteContacts(index) {
    favouriteContact.add(index);
    notifyListeners();
  }

  

  // make a direct phone call
  Future<void> makeCall(index) async {
    bool? result = await FlutterPhoneDirectCaller.callNumber(index);
  }

  // get call type
  getCallType(CallType callType) {
    switch (callType) {
      case CallType.outgoing:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.green,
          backgroundColor: Colors.grey,
        );
      case CallType.missed:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.red,
          backgroundColor: Colors.red.shade400,
        );
      default:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.indigo.shade700,
          backgroundColor: Colors.indigo.shade700,
        );
    }
  }

  // get call type
  getIcons(CallType callType) {
    switch (callType) {
      case CallType.outgoing:
        return LineIcon(
          Icons.arrow_outward_rounded,
          color: ColorConstant.textColor,
          size: 18,
        );
      case CallType.missed:
        return Transform.rotate(
          angle: 0.7853975,
          child: LineIcon(
            Icons.subdirectory_arrow_left_outlined,
            color: Colors.red.shade800,
            size: 18,
          ),
        );
      default:
        return Transform.rotate(
            angle: 3.14159,
            child: LineIcon(
              Icons.arrow_outward_rounded,
              color: ColorConstant.textColor,
              size: 18,
            ));
    }
  }

  // get call log
  Future<Iterable<CallLogEntry>> getCallLogs() {
    return CallLog.get();
  }

  // get time
  String formatTimestamp(String timestamp) {
    final parsedTimestamp =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    final now = DateTime.now();
    final difference = now.difference(parsedTimestamp);

    if (difference.inMinutes < 1) {
      // Less than 1 minute, show seconds ago
      final secondsAgo = difference.inSeconds;
      return '$secondsAgo seconds ago';
    } else if (difference.inHours < 1) {
      // Less than 1 hour, show minutes ago
      final minutesAgo = difference.inMinutes;
      return '$minutesAgo minutes ago';
    } else if (difference.inDays == 0 && parsedTimestamp.day == now.day) {
      // Same day, show time in 24-hour format
      return DateFormat('jm').format(parsedTimestamp);
    } else if (difference.inDays < 7) {
      // Same day, show time in 24-hour format
      return DateFormat('EE').format(parsedTimestamp);
    } else {
      // Show date and day name in 24-hour format
      return DateFormat('d MMMM').format(parsedTimestamp);
    }
  }

  // get call type
  checkCallType(CallType callType, Iterable<CallLogEntry> callLog, int index) {
    switch (callType) {
      case CallType.missed:
        return Row(
          children: [
            getIcons(callLog.elementAt(index).callType!),
            const SizedBox(width: 5),
            Text(
              'Mobile',
              style: TextStyle(color: Colors.red.shade800, fontSize: 14),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.circle_sharp,
              size: 6,
              color: Colors.red.shade800,
            ),
            const SizedBox(width: 5),
            Text(
              formatTimestamp(callLog.elementAt(index).timestamp!.toString()),
              style: TextStyle(
                color: Colors.red.shade800,
              ),
            ),
          ],
        );
      default:
        return Row(
          children: [
            getIcons(callLog.elementAt(index).callType!),
            const SizedBox(width: 5),
            Text(
              'Mobile',
              style: TextStyle(color: ColorConstant.textColor, fontSize: 14),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.circle_sharp,
              size: 6,
              color: ColorConstant.textColor,
            ),
            const SizedBox(width: 5),
            Text(
              formatTimestamp(callLog.elementAt(index).timestamp!.toString()),
              style: TextStyle(
                color: ColorConstant.textColor,
              ),
            ),
          ],
        );
    }
  }

  // get caller title
  getTitle(CallLogEntry entry) {
    if (entry.name == null) return Text(entry.number!);
    if (entry.name!.isEmpty)
      return Text(entry.number!);
    else
      return Text(entry.name!);
  }
}
