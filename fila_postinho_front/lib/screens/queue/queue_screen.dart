import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/queue_services.dart';
import '../../models/item_model.dart';

class QueueScreen extends StatefulWidget {
  final int queueId;
  const QueueScreen({super.key, required this.queueId});

  @override
  _QueueScreenState createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  late Timer _timer;
  QueueItem? _queueData;
  bool _isLoading = true;
  bool _isLeaving = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _fetchQueueData();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchQueueData();
    });
  }

  Future<void> _fetchQueueData() async {
    try {
      final queueService = Provider.of<QueueService>(context, listen: false);

      final response = await queueService.getPosition();
      if (response?.status == -1) {
        Navigator.of(context).pop();
      }
      setState(() {
        _queueData = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar: ${e.toString()}')),
      );
    }
  }

  Future<void> _leaveQueue() async {
    setState(() => _isLeaving = true);
    try {
      final queueService = Provider.of<QueueService>(context, listen: false);
      await queueService.leaveQueue(widget.queueId);
      Navigator.of(context).pop(); // Volta para tela anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao sair da fila: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLeaving = false);
    }
  }

  Widget _buildStatusContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    QueueItem? item = _queueData;
    switch (item?.status) {
      case 0:
        return _buildRegularStatus(item!.position.toString(),
            item.estimatedTime.toString(), item.specialty);
      case 1:
        return _buildInProgressStatus();
      case 3:
        return _buildMissedTurnStatus();
      case 5:
        return _buildGoToReceptionStatus();
      default:
        return _buildUnknownStatus();
    }
  }

  Widget _buildRegularStatus(String position, String time, String specialty) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatusCard(
          icon: Icons.assignment_turned_in,
          color: Colors.blue,
          children: [
            _buildStatusItem('Posição na Fila:', position),
            _buildStatusItem('Tempo Estimado:', '$time minutos'),
            _buildStatusItem('Especialidade:', specialty),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard(
      {required IconData icon,
      required Color color,
      required List<Widget> children}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Demais métodos de construção de status (mantidos similares por questão de espaço)

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sua Posição na Fila'),
      ),
      body: Center(
        child: _buildStatusContent(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLeaving ? null : _leaveQueue,
        icon: const Icon(Icons.exit_to_app),
        label: Text(_isLeaving ? 'Saindo...' : 'Sair da Fila'),
        //backgroundColor:
        //  _isLeaving ? Colors.grey : Theme.of(context).errorColor,
      ),
    );
  }

  // Métodos para outros status
  Widget _buildInProgressStatus() => _buildStatusCard(
        icon: Icons.access_time,
        color: Colors.orange,
        children: [
          const Text('ATENDIMENTO EM ANDAMENTO',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Por favor aguarde no local', textAlign: TextAlign.center),
        ],
      );

  Widget _buildMissedTurnStatus() => _buildStatusCard(
        icon: Icons.warning,
        color: Colors.red,
        children: [
          const Text('VOCÊ PERDEU SUA VEZ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Por favor, faça uma nova senha',
              textAlign: TextAlign.center),
        ],
      );

  Widget _buildGoToReceptionStatus() => _buildStatusCard(
        icon: Icons.assignment_ind,
        color: Colors.green,
        children: [
          const Text('DIRIJA-SE À RECEPÇÃO',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Aguarde orientação do atendente',
              textAlign: TextAlign.center),
        ],
      );

  Widget _buildUnknownStatus() => _buildStatusCard(
        icon: Icons.error_outline,
        color: Colors.grey,
        children: const [
          Text('STATUS DESCONHECIDO',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Entre em contato com a recepção', textAlign: TextAlign.center),
        ],
      );
}
