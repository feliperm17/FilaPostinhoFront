class Queue {
  final int? queueId;
  final int specialty;
  final DateTime queueDt;
  final int positionNr;
  final int queueSize;
  String? specialtyName;

  Queue({
    this.queueId,
    required this.specialty,
    required this.queueDt,
    required this.positionNr,
    required this.queueSize,
    this.specialtyName,
  });

  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
      queueId: json['queue_id'] != null
          ? int.parse(json['queue_id'].toString())
          : null,
      specialty:
          int.parse(json['specialty'].toString()), // Correctly parsed as int
      queueDt: DateTime.parse(json['queue_dt']),
      positionNr: int.parse(json['position_nr'].toString()),
      queueSize: int.parse(json['queue_size'].toString()),
      specialtyName: json['specialty_name'] ??
          'Especialidade Desconhecida', // 🔹 Agora pega o nome da especialidade!
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'queue_id': queueId,
      'specialty': specialty,
      'queue_dt': queueDt.toIso8601String(),
      'position_nr': positionNr,
      'queue_size': queueSize,
    };
  }
}
