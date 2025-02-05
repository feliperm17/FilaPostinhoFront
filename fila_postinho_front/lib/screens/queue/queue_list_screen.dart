import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/queue_services.dart';
import '../../models/queue_model.dart';
//import '../../services/queue_service.dart';
//import '../../models/queue.dart';

class QueueListScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const QueueListScreen({
    required this.toggleTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final queueService = Provider.of<QueueService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Queues')),
      body: FutureBuilder<List<Queue>>(
        future: queueService.findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No queues found'));
          } else {
            final queues = snapshot.data!;
            return ListView.builder(
              itemCount: queues.length,
              itemBuilder: (context, index) {
                final queue = queues[index];
                return ListTile(
                  title: Text('Queue ID: ${queue.queueId}'),
                  subtitle: Text('Specialty: ${queue.specialty}'),
                  onTap: () {
                    // Navigate to queue detail screen
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