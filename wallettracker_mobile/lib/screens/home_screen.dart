import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'expenses_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  final String userName;
  final String userEmail;
  final bool isPremium;

  const HomeScreen({
    super.key,
    required this.token,
    required this.userName,
    required this.userEmail,
    required this.isPremium,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool _isPremium;
  late String _token; // ✅ token agora é estado local

  @override
  void initState() {
    super.initState();
    _isPremium = widget.isPremium;
    _token = widget.token;
  }

  Future<void> _openProfile() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          token: _token,
          name: widget.userName,
          email: widget.userEmail,
          isPremium: _isPremium,
        ),
      ),
    );

    // ✅ Atualiza premium E token, se houver retorno
    if (result != null) {
      setState(() {
        _isPremium = result['isPremium'] as bool;
        _token = result['token'] as String;
      });
    }
  }

  void _openExpenses() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExpensesScreen(
          token: _token,        // ✅ token atualizado
          isPremium: _isPremium,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletTracker'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Olá, ${widget.userName}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                _isPremium ? 'Usuário Premium ⭐' : 'Usuário Normal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isPremium ? Colors.amber[800] : Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openProfile,
                  child: const Text('Perfil'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openExpenses,
                  child: const Text('Despesas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
