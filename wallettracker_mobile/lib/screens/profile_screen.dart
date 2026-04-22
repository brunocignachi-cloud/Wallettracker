import 'package:flutter/material.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  final String token;
  final String name;
  final String email;
  final bool isPremium;

  const ProfileScreen({
    super.key,
    required this.token,
    required this.name,
    required this.email,
    required this.isPremium,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();

  late bool _isPremium;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _isPremium = widget.isPremium;
  }

  /// ⭐ Upgrade para Premium
  Future<void> _upgradeToPremium() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // ✅ backend retorna NOVO TOKEN
      final newToken = await _userService.upgradeToPremium(widget.token);

      if (!mounted) return;

      Navigator.pop(
        context,
        {
          'isPremium': true,
          'token': newToken,
        },
      );
    } catch (_) {
      setState(() {
        _error = 'Erro ao tornar usuário premium';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  /// ⬇️ Downgrade para Normal
  Future<void> _downgradeToNormal() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // ✅ backend retorna NOVO TOKEN
      final newToken = await _userService.downgradeFromPremium(widget.token);

      if (!mounted) return;

      Navigator.pop(
        context,
        {
          'isPremium': false,
          'token': newToken,
        },
      );
    } catch (_) {
      setState(() {
        _error = 'Erro ao voltar para usuário normal';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Widget _buildActionButton() {
    if (_isPremium) {
      return OutlinedButton(
        onPressed: _loading ? null : _downgradeToNormal,
        child: _loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Voltar para usuário normal'),
      );
    }

    return ElevatedButton(
      onPressed: _loading ? null : _upgradeToPremium,
      child: _loading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Tornar-se Premium ⭐'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Nome',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(widget.name),
            const SizedBox(height: 12),

            Text(
              'Email',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(widget.email),
            const SizedBox(height: 24),

            Row(
              children: [
                const Text('Status: '),
                Text(
                  _isPremium ? 'Premium ⭐' : 'Normal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isPremium ? Colors.amber[800] : Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: _buildActionButton(),
            ),

            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}