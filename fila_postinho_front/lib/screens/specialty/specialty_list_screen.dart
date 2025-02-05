import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/specialty_service.dart';
import '../../models/specialty_model.dart';

class SpecialtyListScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const SpecialtyListScreen({
    required this.toggleTheme,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final specialtyService = Provider.of<SpecialtyService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Specialties')),
      body: FutureBuilder<List<Specialty>>(
        future: specialtyService.findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No specialties found'));
          } else {
            final specialties = snapshot.data!;
            return ListView.builder(
              itemCount: specialties.length,
              itemBuilder: (context, index) {
                final specialty = specialties[index];
                return ListTile(
                  title: Text(specialty.specialtyName),
                  onTap: () {
                    // Navigate to specialty detail screen
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}