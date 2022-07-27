import 'dart:convert';

import 'package:e2e_period_tracking/models/symptom.dart';
import 'package:e2e_period_tracking/utils/codable.dart';

class TrackingDay extends Codable {
  DateTime? date;
  Period? period;
  List<Symptom>? symptoms;
  List<String>? notes;

  bool get hasSymptoms => symptoms?.isNotEmpty == true;
  bool get hasNotes => notes?.isNotEmpty == true;

  bool isThisDay({required DateTime other}) =>
      date?.year == other.year &&
      date?.month == other.month &&
      date?.day == other.day;

  TrackingDay({
    this.date,
    this.period = Period.noFlow,
    this.symptoms,
    this.notes,
  });

  @override
  void decode(String data) {
    final jsonData =
        Map<String, String>.from(json.decode(data) as Map<String, dynamic>);
    date = DateTime.parse(jsonData['date'] as String);
    period = Period.values[jsonData['period'] as int];
    symptoms = (jsonData['symptoms'] as List<dynamic>)
        .map((symptom) => Symptom.values[symptom as int])
        .toList();
    notes = jsonData['notes'] as List<String>;
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date'] as String);
    period = Period.values[json['period'] as int];
    symptoms = json['symptoms'] != null
        ? List<int>.from(json['symptoms'])
            .map((symptom) => Symptom.values[symptom])
            .toList()
        : null;
    notes = json['notes'] != null ? List<String>.from(json['notes']) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
        'date': date?.toIso8601String(),
        'period': period?.index,
        'symptoms': symptoms?.map((symptom) => symptom.index).toList(),
        'notes': notes,
      };
}
