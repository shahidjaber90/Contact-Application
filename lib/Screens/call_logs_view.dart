import 'package:call_log/call_log.dart';
import 'package:contact_app/Provider/Contact_view_provider.dart';
import 'package:contact_app/Utils/colors.dart';
import 'package:flutter/material.dart';

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
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = call1.getCallLogs();
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

  getTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                        return GestureDetector(
                          child: Card(
                            child: ListTile(
                                // avatar
                                leading: call1.getCallType(
                                    callLog.elementAt(index).callType!),
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
