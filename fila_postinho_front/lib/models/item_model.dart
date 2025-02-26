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
  factory QueueItem.notOnQueue() {
    return QueueItem(
      queueId: 0,
      specialtyId: 0,
      specialty: '',
      status: -1,
      position: 0,
      estimatedTime: 0,
    );
  }
}

class QueueItemAccount {
  final int? queueId;
  final int specialtyId;
  final String specialty;
  final int status;
  final int position;
  final int estimatedTime;
  int? account;

  QueueItemAccount({
    required this.queueId,
    required this.specialtyId,
    required this.specialty,
    required this.status,
    required this.position,
    required this.estimatedTime,
    this.account,
  });

  factory QueueItemAccount.fromJson(Map<String, dynamic> json) {
    // Handle the JSON structure from the backend
    print("Raw JSON for QueueItemAccount: $json");

    try {
      return QueueItemAccount(
          queueId: json['queue_id'] != null
              ? int.parse(json['queue_id'].toString())
              : null,
          specialtyId: json['specialty'] != null
              ? int.parse(json['specialty'].toString())
              : 0,
          specialty: json['specialty_name']?.toString() ?? '',
          status: json['item_st'] != null
              ? int.parse(json['item_st'].toString())
              : 0,
          position: json['position'] != null
              ? int.parse(json['position'].toString())
              : 0,
          estimatedTime: json['estimated_time'] != null
              ? int.parse(json['estimated_time'].toString())
              : 0,
          account:
              json['account_id'] != null && json['account_id'].toString() != '0'
                  ? int.parse(json['account_id'].toString())
                  : null);
    } catch (e) {
      print("Error parsing QueueItemAccount: $e");
      print("JSON: $json");
      rethrow;
    }
  }

  String get statusText {
    switch (status) {
      case 0:
        return 'EM ESPERA';
      case 1:
        return 'SENDO ATENDIDO';
      case 5:
        return 'AGUARDANDO';
      default:
        return 'DESCONHECIDO';
    }
  }
}
