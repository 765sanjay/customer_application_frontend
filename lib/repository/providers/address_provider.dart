import 'package:flutter/foundation.dart';

class Address {
  final String id;
  final String name;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String phoneNumber;
  bool isDefault; // Removed final to make it mutable

  Address({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phoneNumber,
    this.isDefault = false,
  });
}

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];

  List<Address> get addresses => [..._addresses];

  void addAddress(Address address) {
    _addresses.add(address);
    notifyListeners();
  }

  void removeAddress(String id) {
    _addresses.removeWhere((address) => address.id == id);
    notifyListeners();
  }

  void setDefaultAddress(String id) {
    for (var address in _addresses) {
      address.isDefault = address.id == id;
    }
    notifyListeners();
  }
}