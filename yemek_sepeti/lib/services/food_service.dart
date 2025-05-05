import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food.dart';

class FoodService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const String _apiKey = '1'; // Ücretsiz API key

  Future<List<Food>> getFoods() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/search.php?s='));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data['meals'] as List<dynamic>;
        
        return meals.map((meal) {
          return Food(
            id: meal['idMeal'],
            name: meal['strMeal'],
            description: meal['strInstructions'] ?? '',
            price: double.parse(meal['idMeal']) % 100 + 50, // Rastgele fiyat
            imageUrl: meal['strMealThumb'],
            category: meal['strCategory'],
          );
        }).toList();
      } else {
        throw Exception('Yemekler yüklenirken bir hata oluştu');
      }
    } catch (e) {
      throw Exception('Yemekler yüklenirken bir hata oluştu: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/categories.php'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categories = data['categories'] as List<dynamic>;
        
        return categories.map((category) => category['strCategory'] as String).toList();
      } else {
        throw Exception('Kategoriler yüklenirken bir hata oluştu');
      }
    } catch (e) {
      throw Exception('Kategoriler yüklenirken bir hata oluştu: $e');
    }
  }

  Future<List<Food>> searchFoods(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data['meals'] as List<dynamic>? ?? [];
        
        return meals.map((meal) {
          return Food(
            id: meal['idMeal'],
            name: meal['strMeal'],
            description: meal['strInstructions'] ?? '',
            price: double.parse(meal['idMeal']) % 100 + 50,
            imageUrl: meal['strMealThumb'],
            category: meal['strCategory'],
          );
        }).toList();
      } else {
        throw Exception('Arama yapılırken bir hata oluştu');
      }
    } catch (e) {
      throw Exception('Arama yapılırken bir hata oluştu: $e');
    }
  }
} 