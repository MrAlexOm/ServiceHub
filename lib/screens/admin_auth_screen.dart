import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth_config.dart';

class AdminAuthScreen extends StatefulWidget {
  const AdminAuthScreen({super.key});

  @override
  State<AdminAuthScreen> createState() => _AdminAuthScreenState();
}

class _AdminAuthScreenState extends State<AdminAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int _attemptCount = 0;
  bool _showError = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('admin_email');
    final savedPassword = prefs.getString('admin_password');
    
    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
      });
    }
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_email', email);
    await prefs.setString('admin_password', password);
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _showError = false;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (WHITELIST_EMAILS.contains(email)) {
      // Success
      await _saveCredentials(email, password);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        _showSuccessDialog();
      }
    } else {
      // Failed
      setState(() {
        _attemptCount++;
        _isLoading = false;
        if (_attemptCount >= 2) {
          _showError = true;
        }
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Успех!'),
        content: const Text('Авторизация прошла успешно!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to admin dashboard (placeholder)
              Navigator.of(context).pushReplacementNamed('/admin_dashboard');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Авторизация Админа'),
        backgroundColor: const Color(0xFF6C757D),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Авторизация Админа',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Email field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF5EEAD4), // Soft turquoise
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF5EEAD4), // Soft turquoise
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF14B8A6), // Darker turquoise
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                labelStyle: const TextStyle(
                  color: Color(0xFF64748B),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            
            const SizedBox(height: 20),
            
            // Password field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Пароль',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF5EEAD4), // Soft turquoise
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF5EEAD4), // Soft turquoise
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF14B8A6), // Darker turquoise
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                labelStyle: const TextStyle(
                  color: Color(0xFF64748B),
                ),
              ),
              obscureText: true,
            ),
            
            const SizedBox(height: 20),
            
            // Error message
            if (_showError)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Ошибка email. Обратитесь к супер-админу.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            
            if (_showError) const SizedBox(height: 20),
            
            // Login button
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF17A2B8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2, // Soft shadow
                shadowColor: Colors.black.withOpacity(0.1),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Вход',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            
            const SizedBox(height: 20),
            
            // Back button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6C757D),
              ),
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
