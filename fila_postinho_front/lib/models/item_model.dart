class QueueItem {
  final int? queueId;
  final int specialtyId;
  final String specialty;
  final int status;
  final int position;
  final int estimatedTime;

  QueueItem({
    required this.queueId,
    required this.specialtyId,
    required this.specialty,
    required this.status,
    required this.position,
    required this.estimatedTime,
  });

  factory QueueItem.fromJson(Map<String, dynamic> json) {
    return QueueItem(
      queueId: int.parse(json['queue_id'].toString()),
      specialtyId: int.parse(json['specialty_id'].toString()),
      specialty: json['specialty'].toString(),
      status: int.parse(json['item_st'].toString()),
      position: int.parse(json['position'].toString()),
      estimatedTime: int.parse(json['estimated_wait'].toString()),
    );
  }
}
