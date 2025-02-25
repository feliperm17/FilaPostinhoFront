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

  Future<void> _promoteUser(int id) async {
    try {
      await _userService.promoteUser(id);
      _loadUsers(); // Recarrega a lista de usuários após a promoção
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User promoted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to promote user: $e')),
      );
    }
  }

  Future<void> _demoteUser(int id) async {
    try {
      await _userService.demoteUser(id);
      _loadUsers(); // Recarrega a lista de usuários após o rebaixamento
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User demoted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to demote user: $e')),
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
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: 
                    user.isAdmin?
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.shield, color: const Color.fromARGB(255, 255, 255, 255)),
                    ): CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        user.isAdmin?
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          color: Colors.red,
                          tooltip: 'Rebaixar usuário',
                          onPressed: () => _demoteUser(user.id),
                        ):
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          color: Colors.green,
                          tooltip: 'Promover usuário',
                          onPressed: () => _promoteUser(user.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.redAccent,
                          tooltip: 'Excluir usuário',
                          onPressed: () => _deleteUser(user.id),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navegar para a tela de edição de usuário (opcional)
                    },
                  ),
                );
              },
            ),
    );
  }
}