import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartItem {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String image;
  final bool isFlashProduct;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    required this.isFlashProduct,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'image': image,
      'isFlashProduct': isFlashProduct,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      price: json['price'].toDouble(),
      image: json['image'],
      isFlashProduct: json['isFlashProduct'] ?? false,
      quantity: json['quantity'],
    );
  }
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  final String userId = '1'; // TODO: Replace with actual user ID from auth
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> fetchCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/flash/cart/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> cartData = json.decode(response.body);
        _items = {};
        for (var item in cartData) {
          final cartItem = CartItem.fromJson(item);
          _items[cartItem.id] = cartItem;
        }
      } else {
        _error = 'Failed to fetch cart';
      }
    } catch (e) {
      _error = 'Error fetching cart: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addItem(String productId, String name, String brand, double price, String image, {bool isFlashProduct = false}) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/flash/add/product'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'productId': productId,
          'name': name,
          'brand': brand,
          'price': price,
          'image': image,
          'isFlashProduct': isFlashProduct,
          'quantity': 1,
        }),
      );

      if (response.statusCode == 200) {
        if (_items.containsKey(productId)) {
          _items.update(
            productId,
            (existingCartItem) => CartItem(
              id: existingCartItem.id,
              name: existingCartItem.name,
              brand: existingCartItem.brand,
              price: existingCartItem.price,
              image: existingCartItem.image,
              isFlashProduct: existingCartItem.isFlashProduct,
              quantity: existingCartItem.quantity + 1,
            ),
          );
        } else {
          _items.putIfAbsent(
            productId,
            () => CartItem(
              id: productId,
              name: name,
              brand: brand,
              price: price,
              image: image,
              isFlashProduct: isFlashProduct,
            ),
          );
        }
        notifyListeners();
      } else {
        _error = 'Failed to add item to cart';
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error adding item to cart: $e';
      notifyListeners();
    }
  }

  Future<void> removeItem(String productId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/flash/remove/cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'productId': productId,
        }),
      );

      if (response.statusCode == 200) {
        _items.remove(productId);
        notifyListeners();
      } else {
        _error = 'Failed to remove item from cart';
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error removing item from cart: $e';
      notifyListeners();
    }
  }

  Future<void> clear() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/flash/clear/cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        _items = {};
        notifyListeners();
      } else {
        _error = 'Failed to clear cart';
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error clearing cart: $e';
      notifyListeners();
    }
  }

  Future<void> updateCart() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/flash/update/cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'items': _items.values.map((item) => item.toJson()).toList(),
        }),
      );

      if (response.statusCode != 200) {
        _error = 'Failed to update cart';
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error updating cart: $e';
      notifyListeners();
    }
  }

  Future<void> increaseQuantity(String productId) async {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          brand: existingCartItem.brand,
          price: existingCartItem.price,
          image: existingCartItem.image,
          isFlashProduct: existingCartItem.isFlashProduct,
          quantity: existingCartItem.quantity + 1,
        ),
      );
      notifyListeners();
      await updateCart();
    }
  }

  Future<void> decreaseQuantity(String productId) async {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items.update(
          productId,
          (existingCartItem) => CartItem(
            id: existingCartItem.id,
            name: existingCartItem.name,
            brand: existingCartItem.brand,
            price: existingCartItem.price,
            image: existingCartItem.image,
            isFlashProduct: existingCartItem.isFlashProduct,
            quantity: existingCartItem.quantity - 1,
          ),
        );
      } else {
        await removeItem(productId);
        return;
      }
      notifyListeners();
      await updateCart();
    }
  }
} 