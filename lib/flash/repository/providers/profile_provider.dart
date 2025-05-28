import 'package:flutter/foundation.dart';

class ProfileProvider with ChangeNotifier {
  String _fullName = 'Sarah Johnson';
  String _email = 'sarah.johnson@example.com';
  String _phoneNumber = '+1 (555) 123-4567';
  List<Map<String, String>> _addresses = [
    {
      'name': 'Home',
      'address': '123 Main St, Apt 4B\nNew York, NY 10001\nUnited States',
      'phone': '+1234567890',
      'isDefault': 'true'
    },
    {
      'name': 'Work',
      'address': '456 Business Ave, Floor 12\nNew York, NY 10005\nUnited States',
      'phone': '+0987654321',
      'isDefault': 'false'
    },
  ];

  // Fields for saved addresses and selected address
  late List<String> _savedAddresses;
  String _selectedAddress = '';

  // Constructor to initialize saved addresses
  ProfileProvider() {
    _savedAddresses = _addresses.map((addr) => addr['address'] ?? '').toList();
    _selectedAddress = defaultAddress['address'] ?? '';
  }

  // Getters
  String get fullName => _fullName;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  List<Map<String, String>> get addresses => [..._addresses];
  List<String> get savedAddresses => _savedAddresses;
  String get selectedAddress => _selectedAddress;

  // Get default address
  Map<String, String> get defaultAddress {
    return _addresses.firstWhere(
          (addr) => addr['isDefault'] == 'true',
      orElse: () => _addresses.first,
    );
  }

  // Setters
  void updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
  }) {
    if (fullName != null) _fullName = fullName;
    if (email != null) _email = email;
    if (phoneNumber != null) _phoneNumber = phoneNumber;
    notifyListeners();
  }

  void addAddress(Map<String, String> address) {
    _addresses.add(address);
    _savedAddresses.add(address['address'] ?? '');
    notifyListeners();
  }

  void updateAddress(int index, Map<String, String> address) {
    if (index >= 0 && index < _addresses.length) {
      _addresses[index] = address;
      _savedAddresses[index] = address['address'] ?? '';
      notifyListeners();
    }
  }

  void removeAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      _addresses.removeAt(index);
      _savedAddresses.removeAt(index);
      notifyListeners();
    }
  }

  void setDefaultAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      for (var i = 0; i < _addresses.length; i++) {
        _addresses[i]['isDefault'] = (i == index).toString();
      }
      _selectedAddress = _addresses[index]['address'] ?? '';
      notifyListeners();
    }
  }

  // Method to update the entire addresses list
  void updateAddresses(List<Map<String, String>> newAddresses) {
    _addresses = [...newAddresses];
    _savedAddresses = newAddresses.map((addr) => addr['address'] ?? '').toList();
    _selectedAddress = defaultAddress['address'] ?? '';
    notifyListeners();
  }

  // Methods for saved addresses and selected address
  void updateSavedAddresses(List<String> addresses) {
    _savedAddresses = addresses;
    notifyListeners();
  }

  void updateSelectedAddress(String address) {
    if (_savedAddresses.contains(address)) {
      _selectedAddress = address;
      notifyListeners();
    }
  }
}