class Reminder {
  final int? id;
  final int plantId;
  final String title;
  final String description;
  final DateTime scheduledTime;
  final bool isActive;

  Reminder({
    this.id,
    required this.plantId,
    required this.title,
    required this.description,
    required this.scheduledTime,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plantId': plantId,
      'title': title,
      'description': description,
      'scheduledTime': scheduledTime.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      plantId: map['plantId'],
      title: map['title'],
      description: map['description'],
      scheduledTime: DateTime.parse(map['scheduledTime']),
      isActive: map['isActive'] == 1,
    );
  }

  Reminder copyWith({
    int? id,
    int? plantId,
    String? title,
    String? description,
    DateTime? scheduledTime,
    bool? isActive,
  }) {
    return Reminder(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isActive: isActive ?? this.isActive,
    );
  }
}
