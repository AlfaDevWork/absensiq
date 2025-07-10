class Batch {
  final int id;
  final String batchKe;

  Batch({required this.id, required this.batchKe});

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(id: json['id'], batchKe: "Batch ke-${json['batch_ke']}");
  }
}
