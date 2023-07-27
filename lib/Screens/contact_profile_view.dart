import 'package:contact_app/Provider/Contact_view_provider.dart';
import 'package:contact_app/Utils/colors.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactProfile extends StatelessWidget {
  const ContactProfile({super.key});

  @override
  Widget build(BuildContext context) {
    String? mobileNumber;
    _launchURL() async {
      final url = mobileNumber!;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    Contact contact;

    List<Contact> profile = context.watch<ContactViewProvider>().profileContact;
    List<Contact> favourite =
        context.watch<ContactViewProvider>().favouriteContact;
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.whiteColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.mode_edit_outlined,
                color: ColorConstant.textColor,
              )),
          IconButton(
              onPressed: () async {
                profile.clear();
                if (!favourite.contains(favourite.indexed)) {
                  await context
                      .read<ContactViewProvider>()
                      .favouriteContacts(favourite.indexed);
                  print('profile:: $favourite');
                }
              },
              icon: Icon(
                Icons.star_border_outlined,
                color: ColorConstant.textColor,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert_outlined,
                color: ColorConstant.textColor,
              )),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 1.00,
        child: ListView.builder(
          itemCount: profile.length,
          itemBuilder: (context, index) {
            contact = profile[index];
            return Column(
              children: [
                (profile[index].avatar != null &&
                        profile[index].avatar!.isNotEmpty)
                    ? Container(
                        height: 280,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(profile[index].avatar!),
                                fit: BoxFit.fill)))
                    : Container(
                        alignment: Alignment.center,
                        height: 150,
                        width: double.infinity,
                        child: CircleAvatar(
                          radius: 50,
                          child: Text(
                            profile[index].initials(),
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
                        profile[index].displayName!,
                        style: GoogleFonts.adamina(
                            letterSpacing: 1,
                            fontSize: 24,
                            color: ColorConstant.textColor),
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 18,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // call
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              final Uri url = Uri(
                                scheme: 'tel',
                                path:
                                    profile[index].phones![0].value.toString(),
                              );
                              bool? result =
                                  await FlutterPhoneDirectCaller.callNumber(
                                      profile[index]
                                          .phones![0]
                                          .value
                                          .toString());
                              // if (await canLaunchUrl(url)) {
                              //   await launchUrl(url);
                              // } else {
                              //   print('Cannot Launch Url');
                              // }
                            },
                            icon: const Icon(
                              Icons.call_outlined,
                              size: 24,
                              color: Color.fromARGB(255, 6, 56, 96),
                            )),
                        const Text(
                          'Call',
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 0.5,
                              color: Color.fromARGB(255, 6, 56, 96)),
                        )
                      ],
                    ),
                    // text
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              final Uri url = Uri(
                                scheme: 'sms',
                                path:
                                    profile[index].phones![0].value.toString(),
                              );
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                print('Cannot Launch Url');
                              }
                            },
                            icon: const Icon(
                              Icons.message_outlined,
                              size: 24,
                              color: Color.fromARGB(255, 6, 56, 96),
                            )),
                        const Text(
                          'Text',
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 0.5,
                              color: Color.fromARGB(255, 6, 56, 96)),
                        )
                      ],
                    ),
                    // video
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              final url = Uri.parse(
                                  'whatsapp://send?phone=${profile[index].phones![0].value}');

                              await launchUrl(url);
                            },
                            icon: const LineIcon.whatSApp(
                              size: 30,
                              color: Colors.green,
                            )),
                        const Text(
                          'Whatsapp',
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 0.5,
                              color: Color.fromARGB(255, 6, 56, 96)),
                        )
                      ],
                    ),
                  ],
                ),
                const Divider(
                  height: 18,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        color: ColorConstant.silverGreyColor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Contact info',
                                style: GoogleFonts.lato(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      final Uri url = Uri(
                                        scheme: 'tel',
                                        path: profile[index]
                                            .phones![0]
                                            .value
                                            .toString(),
                                      );
                                      bool? result =
                                          await FlutterPhoneDirectCaller
                                              .callNumber(profile[index]
                                                  .phones![0]
                                                  .value
                                                  .toString());
                                      // if (await canLaunchUrl(url)) {
                                      //   await launchUrl(url);
                                      // } else {
                                      //   print('Cannot Launch Url');
                                      // }
                                    },
                                    icon: const Icon(
                                      Icons.call_outlined,
                                      size: 28,
                                      color: Color.fromARGB(255, 6, 56, 96),
                                    )),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 130,
                                      child: SelectableText(
                                        profile[index].phones![0].value!,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const SizedBox(
                                      width: 130,
                                      child: Text(
                                        'Mobile',
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      final Uri url = Uri(
                                        scheme: 'sms',
                                        path: profile[index]
                                            .phones![0]
                                            .value
                                            .toString(),
                                      );
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        print('Cannot Launch Url');
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.message_outlined,
                                      size: 28,
                                      color: Color.fromARGB(255, 6, 56, 96),
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      final url = Uri.parse(
                                          'whatsapp://send?phone=${profile[index].phones![0].value}');

                                      await launchUrl(url);
                                    },
                                    icon: const LineIcon.whatSApp(
                                      size: 36,
                                      color: Colors.green,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
