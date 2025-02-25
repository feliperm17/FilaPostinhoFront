import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../utils/jwt_token.dart';

class UserManagementScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const UserManagementScreen({super.key, required this.toggleTheme});

  @override
  UserManagementScreenState createState() => UserManagementScreenState();
}

class UserManagementScreenState extends State<UserManagementScreen> {
  late UserService _userService;
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userService = UserService(Provider.of<ApiService>(context, listen: false));
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _userService.findAllUsers(jwtToken!);
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    }
  }

  Future<void> _deleteUser(int id) async {
    try {
      await _userService.deleteUser(id);
      _loadUsers(); // Recarrega a lista de usuários após a exclusão
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Usuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteUser(user.id),
                  ),
                  onTap: () {
                    // Navegar para a tela de edição de usuário (opcional)
                  },
                );
              },
            ),
    );
  }
}