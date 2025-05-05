import 'package:flutter/foundation.dart';
import '../models/food.dart';
import '../services/food_service.dart';

class FoodProvider with ChangeNotifier {
  final FoodService _foodService = FoodService();
  List<Food> _foods = [];
  List<String> _categories = [];
  String? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  List<Food> get foods => _foods;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Food> get filteredFoods {
    var filtered = _foods;
    
    if (_selectedCategory != null) {
      filtered = filtered.where((food) => food.category == _selectedCategory).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((food) =>
          food.name.toLowerCase().contains(query) ||
          food.description.toLowerCase().contains(query)).toList();
    }
    
    return filtered;
  }

  Future<void> loadFoods() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _foods = await _foodService.getFoods();
      _categories = await _foodService.getCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> searchFoods(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _foods = await _foodService.searchFoods(query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 