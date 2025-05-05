import '../models/user.dart';

abstract class IUserRepository {
  Future<User?> login(String email, String password);
  Future<User?> register(String email, String password, String name);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> updateUser(User user);
}

class UserRepository implements IUserRepository {
  final List<User> _users = [];
  User? _currentUser;

  @override
  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simüle edilmiş gecikme

    final user = _users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('Geçersiz email veya şifre'),
    );

    _currentUser = user;
    return user;
  }

  @override
  Future<User?> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1)); // Simüle edilmiş gecikme

    if (_users.any((user) => user.email == email)) {
      throw Exception('Bu email adresi zaten kullanılıyor');
    }

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
    );

    _users.add(user);
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1)); // Simüle edilmiş gecikme
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(seconds: 1)); // Simüle edilmiş gecikme
    return _currentUser;
  }

  @override
  Future<void> updateUser(User user) async {
    _currentUser = user;
  }
} 