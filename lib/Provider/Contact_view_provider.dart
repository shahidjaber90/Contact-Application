import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactViewProvider with ChangeNotifier {
  List<Contact> profileContact = [];

  viewProfile(index) {
    profileContact.add(index);
    
  }
}
