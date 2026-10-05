class Activity {
  final String id;
  final String time;
  final String title;
  final String location;
  bool isCompleted;

  Activity({
    required this.id,
    required this.time,
    required this.title,
    required this.location,
    required this.isCompleted,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      time: json['time'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'title': title,
      'location': location,
      'isCompleted': isCompleted,
    };
  }
}

class TripDay {
  final int dayIndex;
  final String dateTitle;
  final List<Activity> activities;

  TripDay({
    required this.dayIndex,
    required this.dateTitle,
    required this.activities,
  });

  factory TripDay.fromJson(Map<String, dynamic> json) {
    var rawActs = json['activities'] as List<dynamic>? ?? [];
    List<Activity> actList =
        rawActs.map((item) => Activity.fromJson(item as Map<String, dynamic>)).toList();

    return TripDay(
      dayIndex: json['dayIndex'] as int,
      dateTitle: json['dateTitle'] as String,
      activities: actList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayIndex': dayIndex,
      'dateTitle': dateTitle,
      'activities': activities.map((a) => a.toJson()).toList(),
    };
  }
}

class Trip {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final List<TripDay> days;

  Trip({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.days,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    var rawDays = json['days'] as List<dynamic>? ?? [];
    List<TripDay> dayList =
        rawDays.map((item) => TripDay.fromJson(item as Map<String, dynamic>)).toList();

    return Trip(
      id: json['id'] as String,
      title: json['title'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      location: json['location'] as String,
      days: dayList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'days': days.map((d) => d.toJson()).toList(),
    };
  }
}
