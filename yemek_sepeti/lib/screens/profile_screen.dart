import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kişisel Ayarlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (user != null) ...[
            CircleAvatar(
              radius: 40,
              backgroundColor: themeProvider.mainColor.shade100,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: TextStyle(fontSize: 36, color: themeProvider.mainColor),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                user.email,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 32),
          ],
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Tema'),
            subtitle: const Text('Uygulama temasını değiştir'),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              onChanged: (mode) {
                if (mode != null) themeProvider.setThemeMode(mode);
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Açık'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Koyu'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('Sistem'),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Ana Renk'),
            subtitle: const Text('Uygulamanın ana rengini seç'),
            trailing: DropdownButton<MaterialColor>(
              value: themeProvider.mainColor,
              onChanged: (color) {
                if (color != null) themeProvider.setMainColor(color);
              },
              items: const [
                DropdownMenuItem(
                  value: Colors.red,
                  child: Text('Kırmızı'),
                ),
                DropdownMenuItem(
                  value: Colors.purple,
                  child: Text('Mor'),
                ),
                DropdownMenuItem(
                  value: Colors.blue,
                  child: Text('Mavi'),
                ),
                DropdownMenuItem(
                  value: Colors.green,
                  child: Text('Yeşil'),
                ),
                DropdownMenuItem(
                  value: Colors.orange,
                  child: Text('Turuncu'),
                ),
              ],
            ),
          ),
          const Divider(height: 40),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Şifre Değiştir'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const _ChangePasswordDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AlertDialog(
      title: const Text('Şifre Değiştir'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(labelText: 'Mevcut Şifre'),
              obscureText: true,
              validator: (value) => value == null || value.isEmpty ? 'Mevcut şifreyi girin' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'Yeni Şifre'),
              obscureText: true,
              validator: (value) => value == null || value.length < 6 ? 'En az 6 karakter' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Yeni Şifre (Tekrar)'),
              obscureText: true,
              validator: (value) => value != _newPasswordController.text ? 'Şifreler eşleşmiyor' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isLoading = true);
                    // Burada gerçek şifre değiştirme işlemi yapılabilir
                    await Future.delayed(const Duration(seconds: 1));
                    setState(() => _isLoading = false);
                    if (mounted) Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Şifre değiştirildi!')),
                    );
                  }
                },
          child: _isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Kaydet'),
        ),
      ],
    );
  }
} 