import 'package:equatable/equatable.dart';

class DojoModel extends Equatable {
  const DojoModel({
    required this.id,
    required this.name,
    required this.icon,
    this.totalXp = 0,
    this.memberIds = const [],
  });

  final String id;
  final String name;
  final String icon;
  final int totalXp;
  final List<String> memberIds;

  @override
  List<Object?> get props => [id, name, totalXp];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'totalXp': totalXp,
      'memberIds': memberIds,
    };
  }

  factory DojoModel.fromMap(Map<String, dynamic> map, String id) {
    return DojoModel(
      id: id,
      name: map['name'] ?? '',
      icon: map['icon'] ?? '🏯',
      totalXp: map['totalXp'] ?? 0,
      memberIds: List<String>.from(map['memberIds'] ?? []),
    );
  }

  DojoModel copyWith({
    String? name,
    String? icon,
    int? totalXp,
    List<String>? memberIds,
  }) {
    return DojoModel(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      totalXp: totalXp ?? this.totalXp,
      memberIds: memberIds ?? this.memberIds,
    );
  }
}
