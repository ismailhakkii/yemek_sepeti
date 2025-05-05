import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> placeOrder(List<CartItem> items, double totalPrice) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Gerçek uygulamada burada API çağrısı yapılacak
      await Future.delayed(const Duration(seconds: 1)); // Simüle edilmiş gecikme

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: List.from(items),
        totalPrice: totalPrice,
        date: DateTime.now(),
        status: 'Hazırlanıyor',
      );

      _orders.insert(0, order);
    } catch (e) {
      _error = 'Sipariş oluşturulurken bir hata oluştu';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Gerçek uygulamada burada API çağrısı yapılacak
      await Future.delayed(const Duration(seconds: 1)); // Simüle edilmiş gecikme
    } catch (e) {
      _error = 'Siparişler yüklenirken bir hata oluştu';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 