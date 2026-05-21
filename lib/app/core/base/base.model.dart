abstract class BaseModel {
  final int? id;
  final int isSync;
  final DateTime? createdAt;

  const BaseModel({
    this.id,
    this.isSync = 0,
    this.createdAt,
  });

  BaseModel.fromMap(Map<String, dynamic> map)
      : id = _parseInt(map['id']),
        isSync = _parseInt(map['is_sync'] ?? map['isSync']) ?? 0,
        createdAt = _parseDate(map['created_at'] ?? map['createdAt']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'is_sync': isSync,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() => toMap();

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
