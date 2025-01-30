class Queue {
  final int? queueId;
  final int specialty;
  final DateTime queueDt;
  final int positionNr;
  final int queueSize;

  Queue({
    this.queueId,
    required this.specialty,
    required this.queueDt,
    required this.positionNr,
    required this.queueSize,
  });

  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
      queueId: json['queue_id'],
      specialty: json['specialty'],
      queueDt: DateTime.parse(json['queue_dt']),
      positionNr: json['position_nr'],
      queueSize: json['queue_size'],
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