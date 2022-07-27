import 'package:e2e_period_tracking/models/symptom.dart';
import 'package:e2e_period_tracking/models/tracking_day.dart';
import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:e2e_period_tracking/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class PeriodTrackItem extends StatelessWidget {
  final double _size = 20;
  final DateTime day;
  final bool isCenter;
  final TrackingDay? trackingDay;

  const PeriodTrackItem({
    Key? key,
    required this.day,
    required this.isCenter,
    this.trackingDay,
  }) : super(key: key);

  bool _isToday() {
    return day.year == DateTime.now().year &&
        day.month == DateTime.now().month &&
        day.day == DateTime.now().day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            color: _isToday()
                ? const Color.fromARGB(255, 120, 255, 190)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Container(
                  height: _size,
                  width: _size,
                  decoration: BoxDecoration(
                    color: trackingDay?.hasSymptoms == true
                        ? const Color.fromARGB(255, 255, 178, 24)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(_size / 2),
                  ),
                ),
                kSizeH8,
                Container(
                  height: _size,
                  width: _size,
                  decoration: BoxDecoration(
                    color: trackingDay?.period != null &&
                            trackingDay?.period != Period.noFlow
                        ? Colors.red
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(_size / 2),
                  ),
                ),
              ],
            ),
          ),
        ),
        kSizeH8,
        CustomText(
          text: day.day.toString(),
          style: TextStyle(
            fontSize: isCenter ? 16 : 12,
            fontWeight: isCenter ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
