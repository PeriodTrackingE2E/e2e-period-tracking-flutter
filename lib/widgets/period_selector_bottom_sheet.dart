import 'package:e2e_period_tracking/models/symptom.dart';
import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:e2e_period_tracking/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class PeriodSelectorBottomSheet extends StatelessWidget {
  final Function(Period) onSelectPeriod;

  const PeriodSelectorBottomSheet({
    Key? key,
    required this.onSelectPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kSizeH16,
                const CustomText(
                  text: "Choose a symptom from list",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                kSizeH16,
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    itemCount: Period.values.length,
                    itemBuilder: (context, index) {
                      final symptom = Period.values[index];
                      return InkWell(
                        onTap: () => onSelectPeriod(symptom),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                            text: symptom.description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
